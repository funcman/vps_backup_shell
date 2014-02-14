vps_backup_shell
===

A VPS backup shell, base on Dropbox Uploader(http://github.com/andreafabrizi/Dropbox-Uploader).
***

## How to use

Install p7zip:

```
sudo apt-get install p7zip-full
```

Download the script of Dropbox Uploader:

```
cd /root
curl "https://raw.github.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh
```

There is a example, to backup my website.

Save this code as "/root/work.sh", and "chmod +x work.sh":

```bash
#!/bin/bash

BASEPATH=$(cd `dirname $0`; pwd)

DBPATH=/tmp/database`date +%Y%m%d`

mkdir -p $DBPATH
mysqldump -umyusername -pmypwd -hlocalhost website_database > $DBPATH/website_database.sql

$BASEPATH/backup.sh -D"$DBPATH" -fsite_db -d7
$BASEPATH/backup.sh -D/var/www -fsite_www -d7

rm -rf $DBPATH
```

Add a line to the crontab file(/etc/crontab):

```
00 15 * * * root /root/work.sh
```

## Licence

Copyright (C) 2014 funcman(hyq1986@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
