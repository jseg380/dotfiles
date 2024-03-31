#!/bin/env python

from datetime import (
    datetime,                           # Getting current time
    time,                               # Getting time from specific format
    timedelta,                          # Comparing two times
    date                                # Creating datetime with time
)     
from os import environ, chmod           # Env. variables, change permissions
from time import sleep                  # Execute periodically
from sys import argv                    # Pass arguments when executing it
import subprocess                       # Running commands in the shell

#···············································································
# DECLARATIONS

home = environ['HOME']
journal_file = f'{home}/.activity.log'
log_file = f'/tmp/activity.log'
icon_path = f'{home}/.local/share/icons/activity/activity.svg'
tmp_file = '/tmp/tmp_activity'

freq = 10       # By default ask every 10 min
warn_time = 5   # Warn about upcoming notification in x seconds 
rest = {'seconds': 7200,    # 7200 seconds == 2 hours
        'count': 1}

# Functions "aliases"
now = datetime.now
def now_str(format:str) -> str:
    return datetime.now().strftime(format)

#···············································································
# FUNCTIONS

def readSchedule(file_name:str) -> dict:
    """
    Reads schedule from file passed as argument

    Parameters
    ----------
    file_name : str
        Path to the file with the schedule

    Format
    ------
    File must have this specific format:
        Day of the week not abreviated (e.g. Sunday)
        Subject BH-EH
        Where BH and EH are beginning and ending hours respectively
        in 24 hour format

        There is no limit of number of subject entries

        Example:
        Monday
        Yoga 10:00-12:30
        Cooking 13:30-14:15
    """
    week_days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 
                 'Friday', 'Saturday', 'Sunday']
    sched = {}

    try:
        f = open(file_name, 'r')
    except:
        Log.write(f'An error occurred trying to open {file_name}')
        exit(1)

    key = ''
    aux_list = []

    for line in f:
        # Comments supported (only full lines)
        if line[0] == '#':
            continue

        if line.replace('\n', '') in week_days:
            if key != '':
                sched.update({key: aux_list})
            key = line.replace('\n', '')    # Next key
            sched.update({key: ''})         # Add new dictionary
            aux_list = []                   # Clear aux list
        else:
            line_split = line.replace('\n', '').split(' ')
            subject = line_split[0]
            hours = tuple(line_split[1].split('-'))
            aux_dict = {hours: subject}
            aux_list.append(aux_dict)

    sched.update({key: aux_list})
    f.close()

    return sched


def inClass(sched:dict) -> bool:
    """
    Checks if there's any class taking place right now
    In case it does it sends a notification asking if attendance to the
    class is expected or not, to write it in the Journal

    Parameters
    ----------
    sched : dict
        Dictionary containing the schedule

    Returns
    -------
    bool 
        True if attendance to class is expected, False otherwise

    Format
    ------
    The same used in readSchedule
    """
    # Locale's full weekday name
    today = now_str('%A')

    try:
        subject = None

        # Write in log today's schedule
        Log.write(f'Schedule for today, {today}:')
        for i in sched[today]:
            Log.write(i, write_time=False)

        for i in sched[today]:
            hour = list(i.keys())[0]
            if isTimeBetween(hour):
                subject = i.get(hour)
                break

        # If subject != None there is class taking place right now
        if subject != None:
            message = f'Are you in {subject} class?'
            notification = Notification(summary='Activity', body=message,
                                        icon=icon_path,
                                        transient=True,
                                        actions=['Yes', 'No'])
            notification.send()

            answer = notification.getAnswer()
            Log.write(f'In {subject} class: {answer}')

            if answer == 'Yes':
                Journal.write(message=f'{subject} class', 
                              interval=(now_str('%H:%M'), hour[1]))
                waitUntil(hour[1])

                # Attended to class
                return True

    except KeyError:
        Log.write(f'No key for today, {today}. Days with keys:')
        for i in sched:
            Log.write(i, write_time=False)

    # Didn't attend to class
    return False


def isTimeBetween(hour:tuple) -> bool:
    """
    Check if current time is between two other times given in a tuple
    Parameters
    ----------
    hour : tuple
        Tuple containing two times with the following format
        H:M , H is hour in range [0-23], M is minute in range [0-59]
    """
    
    ct = now().time()
    t0 = time.fromisoformat(hour[0])
    t1 = time.fromisoformat(f'{hour[1]}:59')    # Included until second 59

    return t0 <= ct and ct <= t1


def waitUntil(hour:str):
    """
    Waits until the hour in the same day specified

    Parameters
    ----------
    hour : str
        Hour to wait until in a valid time format
    """
    # Two datetime.time objects cannot be subtracted
    next_time = datetime.combine(date.today(), time.fromisoformat(hour))
    remaining = (next_time - now()).seconds
    Log.write(f'Sleeping for {remaining} s until {hour}. It\'s {now()}')
    sleep(remaining)


def waitFor(time:int):
    """
    Waits for the time passed as parameter

    Parameters
    ----------
    time : str
        Duration of the waiting in seconds
    """
    Log.write(f'Sleeping for {time} s ({time / 60} min). It\'s {now()}')
    sleep(time)


#···············································································
# CLASSES

class Log:
    """
    Class for logging events
    Attributes
    ----------
    file : str
        Path of the file where logs will be written
    """

    file = log_file

    @classmethod
    def write(cls, message:str, write_time:bool=True):
        """
        Write a log

        Parameters
        ----------
        message : str
            Message to write in the log
        write_time : bool
            Boolean to determine if the time should be written in the log
        """
        with open(cls.file, 'a') as f:
            if write_time:
                t = now_str('[%H:%M:%S]')
                f.write(f'{t}: {message}\n')
            else:
                f.write(f'{message}\n')

    @classmethod
    def read(cls, lines:int=-1, reverse:bool=True) -> list[str]:
        """
        Read the log

        Parameters
        ----------
        lines : int, optional (default = -1)
            Number of lines to read from the log. If lines == -1 or no
            parameter line is passed the whole log is read
        reverse : bool, optional (default = true)
            When true reading begins from the end of the log
        """
        try:
            f = open(cls.file, 'r')

            if lines == -1:
                return f.readlines()
            elif reverse:
                return f.readlines()[-lines:]
            else:
                return f.readline()[:lines]

            f.close()
        except:
            return f'Error opening {cls.file}'

class Notification:
    """
    Class for sending notifications.
    Libnotify and a notification daemon are required.
    """
    urgencies = ['critical', 'normal', 'low']

    def __init__(self, summary:str='', body:str='', name:str=None, 
                 actions:list=None, urgency:str='normal', expire:int=None,
                 icon:str=None, transient:bool=False):
        """
        Constructor
        Parameters
        ----------
        summary : str
            The summary of the notification
        body : str
            Message to complement the summary
        name : str
            Name of the notification
        actions : list
            Possible actions to choose in the notification
        urgency : str
            Urgency of the notification ['critical', 'normal', 'low']
        expire : int
            Expire time of the notification in milliseconds
        icon : str
            Path to a file of the icon or name of the gtk icon.
        transient : bool
            Transient notifications are not saved in the notification tray
        
        Preconditions
        -------------
        summary must not be empty
        """
        # Summary can't be empty
        if summary == '':
            raise ValueError('Summary can\'t be empty')

        self.sum = summary
        self.body = body
        self.actions = actions
        self.answer = None

        self.options = ''

        if name != None:
            self.options += f'--app-name={name} '
        if urgency.lower() in Notification.urgencies:
            self.options += f'--urgency={urgency} '
        if icon != None:
            self.options += f'--icon={icon} '
        if transient != False:
            self.options += f'--transient '
        if actions != None:
            for i in actions:
                self.options += f'--action {i} '

            if expire == None:
                self.options += f'--expire-time=0'
        elif expire != None:
            self.options += f'--expire-time={expire} '

    def send(self):
        """
        Sends notification with the options selected in the constructor
        """
        # Problem: For some reason notify-send returns the process as
        # CompletedProcess after 5 seconds, even though it should wait
        # to be closed when expire time is 0 (when using subprocess.run)
        script = '/tmp/notification_script.sh'
        with open(script, 'w') as f:
            f.write('#!/bin/bash\n')
            f.write(f'notify-send "{self.sum}" "{self.body}" {self.options}')
        
        chmod(script, 0o777)

        if self.actions == None:
            subprocess.run([script])
            subprocess.run(['rm', script])
            return None

        # Returning None to exit function to avoid using if...else causing
        # deep indentation. Somewhat "similar" to guard clauses
        
        # If there are options then do not allow to close the notification
        # without selecting one
        while True:
            self.answer = subprocess.run([script],
                                         stdout=subprocess.PIPE, 
                                         universal_newlines=True)

            if self.answer.stdout != '':
                break

        subprocess.run(['rm', script])

    def getAnswer(self):
        """
        Returns the chosen action of the sent notification
        If the notification sent had no actions 'None' is returned
        """
        if self.answer != None:
            return self.actions[int(self.answer.stdout)]
        else:
            return None

class Journal:
    """
    Class to modify the journal file
    """
    file = journal_file
    
    @classmethod
    def write(cls, message:str, interval:tuple):
        """
        Write a journal log

        Parameters
        ----------
        message : str
            Message to write in the journal
        interval : tuple
            Tuple containing the interval of time to journal about
        """
        with open(cls.file, 'a') as f:
            if interval != None:
                f.write(f'{interval[0]}-{interval[1]} {message}\n')
            else:
                f.write(f'\n{message}\n')

    @classmethod
    def read(cls, lines:int=-1, reverse:bool=True) -> list[str]:
        """
        Read the journal

        Parameters
        ----------
        lines : int, optional (default = -1)
            Number of lines to read from the journal. If lines == -1 or no
            parameter line is passed, the whole journal is read
        reverse : bool, optional (default = true)
            When true reading begins from the end of the journal
        """
        try:
            f = open(cls.file, 'r')

            if lines == -1:
                return f.readlines()
            elif reverse:
                return f.readlines()[-lines:]
            else:
                return f.readline()[:lines]

            f.close()
        except:
            return f'Error opening {cls.file}'



#···············································································
# PROGRAM

# Check if current time is in the schedule
if len(argv) == 2:
    # Read schedule from file passed as argument
    sched = readSchedule(argv[1])

# Ask for the frequency at which to be asked
message = 'Choose interval duration'
freq_notif = Notification(summary='Activity',
                          body=message,
                          icon=icon_path,
                          transient=True,
                          actions=['None', 5, 10, 15, 20, 30])

freq_notif.send()
freq = freq_notif.getAnswer()

if freq == 'None':
    Log.write('Option chosen: Not to start the program')
    Notification(summary='Activity',
                 body='Time won\'t be registered this session',
                 icon=icon_path).send()
    exit(0)


waitFor(1)
Notification(summary='Activity',
             body=f'Time will be registered every {freq} min this session',
             icon=icon_path).send()


Log.write(f'{now_str("%A %d %B %Y - %H:%M:%S")}', write_time=False)
Log.write(f'Interval time chosen: {freq} min = {freq * 60} s')

Journal.write(f'\n{now_str("%A %d %B %Y - %H:%M:%S")}', interval=None)


if len(argv) > 3:
    Log.write('Error. This program takes at maximum 3 arguments. Instead' +
              f'{len(argv)} were given:\n{argv}')

if len(argv) == 2:
    # Read schedule from file passed as argument
    sched = readSchedule(argv[1])

while True:
    in_class = False

    # "Class" notification
    if len(argv) == 2:
        in_class = inClass(sched)
    
    if in_class:
        continue
    
    # "Normal" notification
    t0 = now_str('%H:%M') # Beginning of the interval
    
    waitFor(freq * 60 - warn_time)
    Notification(summary='Activity',
                 body=f'You will be asked in {warn_time} seconds',
                 icon=icon_path,
                 transient=True,
                 expire=3000).send()
    waitFor(warn_time)
   
    if (rest['count'] * freq * 60) >= rest['seconds']:
        rest['count'] = 1
        rest_msg = ('You have been using the pc for ' + rest["seconds"]/60 + 
                    'minutes\nYou should rest now')
        Notification(summary='Activity',
                     body=rest_msg,
                     icon=icon_path,
                     expire=5000).send()

    message = f'Last {freq} min were spent on'
    notification = Notification(summary='Activity',
                                body=message,
                                icon=icon_path,
                                transient=True,
                                actions=['Study', 'Procrastinate', 
                                         'Movie', 'Other'])
    
    notification.send()

    answer = notification.getAnswer()

    t1 = now_str('%H:%M') # End of the interval

    if answer == 'Other':
        with open(tmp_file , 'w') as f:
            f.write(f'What have you been doing for the last {freq} minutes?' +
                    '(Only one line)\n\n')

        subprocess.run(['gedit', tmp_file, '+', '--class', 'popup-input'])
        with open(tmp_file, 'r') as f:
            content = f.readlines()[-1].replace('\n', '')
        subprocess.run(['rm', tmp_file])

        answer = answer + ': ' + content

    Journal.write(message=answer, interval=(t0, t1))
    Log.write(message=f'Interval of time: {(t0, t1)}')

    # Remind of next control
    waitFor(1)
    Notification(summary='Activity',
                 body=f'You will be asked again in {freq} minutes',
                 icon=icon_path,
                 transient=True).send()
