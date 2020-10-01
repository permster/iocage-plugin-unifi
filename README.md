# iocage-plugins-unifi
## Post install steps
### Add permissions using FreeNAS 11.3 ACL manager
1. Click the three dots next to the apps>unifi dataset; in this example, it is called "unifi"
2. Select "Edit ACL"
3. Click the "Add ACL Item" button. A new section will appear at the bottom of the list of existing ACL items.
4. Fill in the following (*note that 351 is the correct user here*):

![ACL Permissions](https://static.ixsystems.co/uploads/2020/02/pasted-image-0-1.png)

Don't worry if it says "Could not find a username for this ID"
5. If files already exist in the dataset, select the "Apply permissions recursively" checkbox.
6. Click "Save"

### Stop the services
```
iocage exec jail_name "service unifi stop"
```
### Add mount points
```
iocage fstab -a jail_name /mnt/pool-1/apps/unifi /usr/local/unifi/data nullfs rw 0 0
```
### Update file ownerships (optional)
```
iocage exec jail_name "chown -R unifi:unifi /config"
```
### Start the services
```
iocage exec jail_name "service unifi start"
```
