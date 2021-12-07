#vc-app is the vision captor helm chart with 2 services as below:
    1. ai pipeline.
    2. vclite.

#Before deploying the application we require k3s to be installed on the machine where we want to deploy charts.

#On the host machine we need to create 3 folders as below and need to place data into it(VSBLTY need to provide data for models & gallery while other folders can be kept empty)

    1.mkdir -p /home/vedge/models
    2.mkdir -p /home/vedge/gallery
    3.mkdir -p /home/vedge/videos
    4.mkdir -p /root/.Xauthority
    5.mkdir -p /home/vclite/Usage
    6.mkdir -p /home/vclite/KioskServicesMedia

#In root values.yaml file of vc-app chart we have couple of things to be filled before deployment.
    1.ai-pipeline.device.accessToken : It'll be generated when the camera will be registered to vsblty portal (manually) and that need to copy in values.yaml file.(VSBLTY can give before deployment).

    2. ai-pipeline.camera.rtsp : It's the camera rtsp stream url.

    3. vclite.display.EndpointId: It's endpoint created in vsblty cms portal application (VSBLTY can give before deployment).

    4. vclite.display.BaseCmsUrl: It's vsblty cms portal url where we have playlist to be played on device.(VSBLTY can give before deployment).


#Once we have all the above things set up we can deploy by following command.

    helm install vc-app vc-app/ -n vsblty
    (where vsblty is namespace in k3s)
