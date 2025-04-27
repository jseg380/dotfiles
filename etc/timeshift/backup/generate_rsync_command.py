import json
import subprocess

exclude_file = {
    'relative_path': './exclude_auto.list',
    'file_template': 
'''
/dev/*
/proc/*
/sys/*
/media/*
/mnt/*
/tmp/*
/run/*
/var/run/*
/var/lock/*
/var/lib/dhcpcd/*
/var/lib/docker/*
/var/lib/schroot/*
/lost+found
/timeshift/*
/timeshift-btrfs/*
/data/*
/DATA/*
/cdrom/*
/sdcard/*
/system/*
/etc/timeshift.json
/var/log/timeshift/*
/var/log/timeshift-btrfs/*
/swapfile
/snap/*
/root/.thumbnails
/root/.cache
/root/.dbus
/root/.gvfs
/root/.local/share/[Tt]rash
/home/*/.thumbnails
/home/*/.cache
/home/*/.dbus
/home/*/.gvfs
/home/*/.local/share/[Tt]rash
/root/.mozilla/firefox/*.default/Cache
/root/.mozilla/firefox/*.default/OfflineCache
/root/.opera/cache
/root/.kde/share/apps/kio_http/cache
/root/.kde/share/cache/http
/home/*/.mozilla/firefox/*.default/Cache
/home/*/.mozilla/firefox/*.default/OfflineCache
/home/*/.opera/cache
/home/*/.kde/share/apps/kio_http/cache
/home/*/.kde/share/cache/http
/var/cache/apt/archives/*
/var/cache/pacman/pkg/*
/var/cache/yum/*
/var/cache/dnf/*
/var/cache/eopkg/*
/var/cache/xbps/*
/var/cache/zypp/*
/var/cache/edb/*
{}
/root/**
/home/*/**
''',
}

def generate_rsync_command(timeshift_json_path):
    with open(timeshift_json_path, 'r') as file:
        config = json.load(file)

    custom_rules = []
    for rule in config.get("exclude", []):
        custom_rules.append(rule)

    with open(exclude_file['relative_path'], 'w') as file:
        formatted_contents = exclude_file['file_template'].format('\n'.join(custom_rules))
        file.write(formatted_contents)

    rsync_command = f"rsync -aii --recursive --verbose --delete --force --stats --sparse --delete-excluded --exclude-from '{exclude_file['relative_path']}' --delete-excluded '/'"

    return rsync_command

if __name__ == "__main__":
    timeshift_json_path = 'timeshift-exclude.json'

    rsync_cmd = generate_rsync_command(timeshift_json_path)
    # print(f"Generated rsync command:\n\n{rsync_cmd}")

    subprocess.run(['sh', '-c', rsync_cmd])
