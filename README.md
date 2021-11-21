# Build php-mapscript and php-geos
## Support
Forked users (e.g., UNH): for upstream support, find this repo maintained at:
https://github.com/mdledoux/mapscript-geos
```bash
git clone git@github.com:mdledoux/mapscript-geos.git
```
or add *another remote* to an existing repo - call it "github":
```bash
git remote add github git@github.com:mdledoux/mapscript-geos.git
```
then you can update your local copy, and even the copy in GitLab with:
```bash
git pull github   # pull from GitHub
git push          # push latest changes to GitLab
```

UNH folks:  Feel free to open a Pull-Request on GitHub - it would be great to continue collaborating in the open-source community!



## Getting started

First, copy the SAMPLE.env file to .env, and pick your container engine (e.g., docker, podman,...)
```bash
cp SAMPLE.env .env
```


## CentOS7.8 PHP 7.2.24 (rh-php72 SCL)
### TL;DR
To simply build the image and create the two containers to copy both RPMs (for php-geos and php-mapscript), simply do the following:
```bash
./build_centos78.sh
./run_centos78_and_copy_rpm_files.sh
# Then sinmply put the resulting RPM files where you need them:
# cp RPM/* DESTINATION

# Now install the PHP exensions...
# MapScript (with the MapServer library):
yum -y install  RPM/libmapserver-7.4.4-0.noarch.rpm  RPM/php-mapscript-7.4.4-7.2.24.noarch.rpm
# GEOS
yum -y install  RPM/php-geos-3.4.2-7.2.24.noarch.rpm
```


### Let's break it down
Build the *separate* images (for separate containers) for mapscript and geos:
```bash
./build_centos78.sh
```
This does:
```bash
docker build -t centos78_php_mapscript . -f centos78.Dockerfile  --target=php_mapscript
docker build -t centos78_php_geos . -f centos78.Dockerfile  --target=php_geos
```
 

This now supports multistage builds (2 stages)

Then, to copy the RPM files to a local **./RPMs** folder you can simply run:
```bash
./run_centos78_and_copy_rpm_files.sh
```
This copies all 3 RPM (2 for MapScript and 1 for GEOS) files - you can selectively copy one or the other by picking one of the following approaches.

### php-mapscript
```bash
docker run -it --rm --name php_mapscript  -v $PWD/RPMs:/RPMs  centos78_php_mapscript
# IN THIS ORDER:
rpm -i  RPMs/libmapserver-7.4.4-0.noarch.rpm   &&  rpm -i RPMs/php-mapscript-7.4.4-7.2.24.noarch.rpm 
# OR this instead:
yum -y install  RPMs/php-mapscript-7.4.4-7.2.24.noarch.rpm  RPMs/libmapserver-7.4.4-0.noarch.rpm 
```

### php-geos
```bash
docker run -it --rm --name php_geos  -v $PWD/RPMs:/RPMs   centos78_php_geos
# Install the single module:
rpm -i  RPMs/php-geos-3.4.2-7.2.24.noarch.rpm
# OR this instead:
yum -y install  RPMs/php-geos-3.4.2-7.2.24.noarch.rpm
```


## Fedora 29, PHP 7.2.24
**NOTE:  `fedora29.Dockerfile` does not yet exist**
```bash
./build_fedora29.sh
docker run -it --rm --name fedora29  -v $PWD/RPMs:/RPMs   fedora29
```


## Query contents of RPM
```bash
rpm -qlp RPMs/mapscript-geos-1-0.noarch.rpm
```




# Notes about building an RPM in the recipe 

## Build process
Because this RPM is shopping with 'so' files, the following error will coccur
```
    Arch dependent binaries in noarch package
error: command 'rpmbuild' failed with exit status 1
```
The solutionn is to add the following to the .rpmmacros file inside image
```bash
echo "%_unpackaged_files_terminate_build      0"  >>  .rpmmacros
echo "%_binaries_in_noarch_packages_terminate_build   0"   >>  .rpmmacros
```
https://stackoverflow.com/questions/21288374/shipping-so-and-binaries-while-building-rpm-package

Then you should be able to go on and build successfully:
```bash
cd rpmbuild
rpmbuild -ba SPECS/mapscript-geos.spec 
```

