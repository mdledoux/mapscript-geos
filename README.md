# Build php-mapscript and php-geos
First, copy the SAMPLE.env file to .env, and pick your container engine (e.g., docker, podman,...)
```bash
cp SAMPLE.env .env
```


## CentOS7.7, PHP 7.2.24
```bash
./build_centos77.sh
docker run -it --rm --name centos77 -d centos77
docker cp centos77:RPM   .
docker stop centos77
```


## Fedora 29, PHP 7.2.24
```bash
./build_fedora29.sh
```




# Building an RPM 

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

## Query contents of RPM
```bash
rpm -qlp RPMS/noarch/mapscript-geos-1-0.noarch.rpm
```


