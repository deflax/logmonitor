```
import syslog_client
log = syslog_client.Syslog("127.0.0.1")
log.notice("info msg")
log.warn("warning msg")
log.error("error msg")
```
```
log.send("howdy", syslog_client.WARNING)
```
