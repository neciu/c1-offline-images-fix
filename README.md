# c1-offline-images-fix

## Description
The instructions below describe how to detect and mark offline photos in Capture One catalog, so the user can filter them out using built-in filtering.

Currently, there is no way to filter offline photos in the C1 library without additional steps.

The solution modifies the offline photos by writing the camera serial number to `offline_photo`, so later the user can filter by this parameter.

To mark your offline photos you'll need:
- SQLite client (e.g. [DB Browser for SQLite](https://formulae.brew.sh/cask/db-browser-for-sqlite#default))
- Text editor (e.g. [VS Code](https://formulae.brew.sh/cask/visual-studio-code#default))
- The `fix.sh` script from this repo

## Insteructions
1. List all photos:

Open your SQLite client and execute this query.
```sql
SELECT printf('%s/%s;%s', p.zrelativepath, i.zimagefilename, i.z_pk) 
FROM zpathlocation AS p
JOIN zimage AS i ON i.zimagelocation = p.z_pk
WHERE p.z_ent=(SELECT z_ent FROM zentities WHERE zname='PathLocation');
```
It will return list of `photo;primary key` paris (e.g. `/c1/originals/DSC00001.ARW;1`).

2. Save the list in a text file, e.g. `all-files.txt`.

3. Run `fix.sh` providing the path to the file above, and base path of your C1 catalog (e.g. `./fix.sh ./all-files.txt /Volumes/photos`).
The script will create a new file named `update-query.sql` with SQL query updating all offline pictures in the catalog. E.g.
```sql
UPDATE zimage
SET ZCAMERA_SERIAL = "offline_photo"
WHERE z_pk IN ("1","3");
```

4. Filter your photos by "Camera Serial" to equals "offline_photo".
<img width="784" alt="Screenshot 2023-02-05 at 14 53 54" src="https://user-images.githubusercontent.com/2368417/216823865-36bfa3f5-3209-4149-925e-ce7d4febb7ff.png">

5. Done
