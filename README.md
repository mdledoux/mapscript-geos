# Build php-mapscript and php-geos
First, copy the SAMPLE.env file to .env, and pick your container engine (e.g., docker, podman,...)
```bash
cp SAMPLE.env .env
```


## CentOS7.7, PHP 7.2.24
Build the **separate** images (for separate containers) for mapscript and geos:
```bash
./build_centos77.sh
```
This does:
```bash
docker build -t centos77_php_mapscript . -f centos77.Dockerfile  --target=php_mapscript
docker build -t centos77_php_geos . -f centos77.Dockerfile  --target=php_geos
```
 

This now supports multistage builds (2 stages)
### php-mapscript
```bash
docker run -it --rm --name php_mapscript -d centos77_php_mapscript
docker cp php_mapscript:RPM .
docker stop php_mapscript
```

### php-geos
```bash
docker run -it --rm --name php_geos -d centos77_php_geos
docker cp php_geos:RPM .
docker stop php_geos
```


## Fedora 29, PHP 7.2.24
```bash
./build_fedora29.sh
docker run -it --rm --name fedora29 -d fedora29
docker cp fedora29:RPM   .
docker stop fedora29
```


## Query contents of RPM
```bash
rpm -qlp RPMS/noarch/mapscript-geos-1-0.noarch.rpm
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

