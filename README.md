# rvgl-packager
Create packs for RVGL Luancher

## Installation
Clone the repository
```
git clone https://github.com/cassbeck/rvgl-packager.git
```

## Usage

### Create a file describing the package content
Get urls of content of your package from https://www.revoltworld.net (only supported site) and add it into a file.

example.txt:
```
https://www.revoltworld.net/dl/snowboardx/
https://www.revoltworld.net/dl/trident/
https://www.revoltworld.net/dl/roomba/
```

### Launch the script

Execute the script with the input file as parameter

```
usage ./rvgl-packager.sh input_file

- input_file: file must contains Re-Volt World URL to add in the package
```

Example:
```
./rvgl-packager.sh example.txt
```

## Output

### Termnial (stdout)
On the terminal you can follow the script processing.

example:
```
https://www.revoltworld.net/dl/snowboardx/
  donwloading...
  processing...
    Name:         SBX Alpine
    Category:     Standard Track
    Folder name:  snowboardx
    Image url:    https://www.revoltworld.net/wp-content/uploads/import/snowboardx.png
    Download url: https://www.revoltworld.net/dl/snowboardx/?ind=0&filename=snowboardx.zip&wpdmdl=1475&refresh=60f4630003bdf1626628864
    Image:        images/SBX_Alpine.png
    Zip File:     zips/snowboardx.zip
https://www.revoltworld.net/dl/trident/
  donwloading...
  processing...
    Name:         Trident
    Category:     Rookie Car
    Folder name:  trident
    Image url:    https://www.revoltworld.net/wp-content/uploads/import/trident.png
    Download url: https://www.revoltworld.net/dl/trident/?ind=0&filename=trident.zip&wpdmdl=17921&refresh=60f4630e902ec1626628878
    Image:        images/Trident.png
    Zip File:     zips/trident.zip
https://www.revoltworld.net/dl/roomba/
  donwloading...
  processing...
    Name:         Roomba RC
    Category:     Misc. Car
    Folder name:  roomba
    Image url:    https://www.revoltworld.net/wp-content/uploads/import/roomba.png
    Download url: https://www.revoltworld.net/dl/roomba/?ind=0&filename=roomba.zip&wpdmdl=24456&refresh=60f463185bccc1626628888
    Image:        images/Roomba_RC.png
    Zip File:     zips/roomba.zip

Generating files...

Generated files:
 - package.json
 - package.zip
 - package.sha256

```

### Files
**package.json**

An output file containing informations about the content of your package in json format. (for future usage)
```
[
  {
    "name":     "SBX Alpine",
    "category": "Standard Track",
    "folder":   "snowboardx",
    "image":    "images/SBX_Alpine.png",
    "zip":      "zips/snowboardx.zip",
    "url":      "https://www.revoltworld.net/dl/snowboardx/"
  }
  ,
  {
    "name":     "Trident",
    "category": "Rookie Car",
    "folder":   "trident",
    "image":    "images/Trident.png",
    "zip":      "zips/trident.zip",
    "url":      "https://www.revoltworld.net/dl/trident/"
  }
  ,
  {
    "name":     "Roomba RC",
    "category": "Misc. Car",
    "folder":   "roomba",
    "image":    "images/Roomba_RC.png",
    "zip":      "zips/roomba.zip",
    "url":      "https://www.revoltworld.net/dl/roomba/"
  }
]
```

**package.zip**

The rvgl-launcher package

**package.sha256**

The sha256sum to use in rvgl-launcher package description

### Directories

**images**

Directory where images from Re-Volt World are copied (for future usage)

**pack**

Directory where packages are unziped

**zips**

Directory containing 
- packages coming from Re-Volt World
- _rvgl_linux.zip_ to extract the script _fix_cases_.

# Include the package in a the rvgl-launcher repository
You can know create your rvgl-launcher repository.
For example `repo.json`:

```
{
    "name": "CassBeck's Repo",
    "version": "21.0718",
    "packages": {
        "cassbeck-pack": {
            "description": "CassBeck pack created by rvgl-pacakger",
            "version": "21.0718",
            "checksum": "<<PUT THE CONTENT OF package.sha256 THERE>>",
            "url": "<<URL OF YOUR SITE>>/package.zip",
            "file": "package.zip"
        }
    }
}    
```

NB: It's recommended to rename the package `package.zip` with something more relevant, for example `cassbeck-pack-210718.zip`

Last step add your repository in rvgl-launcher: https://re-volt.gitlab.io/rvgl-launcher/repos.html

