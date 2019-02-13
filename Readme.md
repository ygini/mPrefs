# mPrefs

mPrefs is here to help macOS SysAdmin to check the managed settings of a preferrences domain, usually not shown by the `defaults` command line.

## Usage

```
mPrefs is a simple command line allowing system administrator to check a target domain with managed preferences applied.

-d com.github.ygini.Hello-IT				Use the -d to specify the target domain to read
-o read							The -o option allow you to select your operation:
								"list" to list all managed keys
								"listall" to list all keys, managed or not
								"read" to read all keys, managed or not
-k content						With -k, you can specify the key to read
								(usable with operation listall and read)
-k 1							When -pk is set to 1, you can use a keypath with -k

More informations on keypath available here: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/CollectionOperators.html
``` 

## Examples

List managed munki settings:
```
$ mPrefs -d ManagedInstalls -o list
SoftwareRepoURL
InstallAppleSoftwareUpdates
```

Reading all munki settings:
```
$ mPrefs -d ManagedInstalls -o read
{
    AppleSoftwareUpdatesOnly = 0;
    ClientIdentifier = "";
    DaysBetweenNotifications = 1;
    FollowHTTPRedirects = none;
    IgnoreSystemProxies = 0;
    InstallAppleSoftwareUpdates = 1;
    InstallRequiresLogout = 0;
    InstalledApplePackagesChecksum = e53e92e6aec61bd231e291f18478c7bd884c520a36d0e23952bf7051cad62429;
    LastAppleSoftwareUpdateCheck = "2019-02-12 21:44:45 +0000";
    LastCheckDate = "2019-02-13 14:15:13 +0000";
    LastCheckResult = 0;
    LastNotifiedDate = "2019-02-09 12:08:31 +0000";
    LogFile = "/Library/Managed Installs/Logs/ManagedSoftwareUpdate.log";
    LogToSyslog = 0;
    LoggingLevel = 1;
    ManagedInstallDir = "/Library/Managed Installs";
    OldestUpdateDays = 0;
    PackageVerificationMode = hash;
    PendingUpdateCount = 0;
    PerformAuthRestarts = 0;
    ShowOptionalInstallsForHigherOSVersions = 0;
    SoftwareRepoURL = "https://munki.example.com";
    SuppressAutoInstall = 0;
    SuppressLoginwindowInstall = 0;
    SuppressStopButtonOnInstall = 0;
    SuppressUserNotification = 0;
    UnattendedAppleUpdates = 0;
    UseClientCertificate = 0;
    UseClientCertificateCNAsClientIdentifier = 0;
}
```

Read specify munki settings:
```
$ mPrefs -d ManagedInstalls -o read -k SoftwareRepoURL
https://munki.example.com
```
