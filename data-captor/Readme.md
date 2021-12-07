#data-captor is the vision captor helm chart with data-captor

#Before deploying the application we require k3s to be installed on the machine where we want to deploy charts.

#On the host machine we need to create 3 folders as below and need to place data into it(VSBLTY need to provide data for models & gallery while other folders can be kept empty)

    1.mkdir -p /home/vedge/models
    2.mkdir -p /home/vedge/gallery
    3.mkdir -p /home/vedge/videos
   

#In values.yaml file of data-captor chart we have couple of things to be filled before deployment.
    1.device.accessToken : It'll be generated when the camera will be registered to vsblty portal (manually) and that need to copy in values.yaml file.(VSBLTY can give before deployment).

    2. camera.rtsp : It's the camera rtsp stream url.



#Once we have all the above things set up we can deploy by following command.

    helm install data-captor data-captor/
