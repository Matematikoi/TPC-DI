# Docker for generating Data
Open two terminals and `cd` to the root of the project

on the first terminal build (only do it once) and run the project.


```sh
# run this from the root of the project
docker build -t tpcdi:0.1 -f javaDocker/Dockerfile .
```
To run the project use 
```sh
docker run -it --rm --name javatpcdi tpcdi:0.1
```

Afterwards you will be inside the project. Now it is time to create the data, 
change the scale factor `-sf 3` as you need. The available range is [3,2147483647]

```sh
cd opt/app
java -jar DIGen.jar -o gendata/ -sf 3
```
This wil activate a prompt. Press Enter and type `YES` then press ENTER again.

In another terminal that is the root folder of the project copy the files
```sh
docker cp javatpcdi:/opt/app/gendata ./sqlDocker/data
```