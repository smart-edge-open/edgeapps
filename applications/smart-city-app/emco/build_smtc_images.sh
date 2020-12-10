yum install cmake m4 -y

#On the OpenNESS EMCO cluster, clone the Smart City Reference Pipeline source code from GitHub and checkout the 577d483635856c1fa3ff0fbc051c6408af725712 commits
git clone https://github.com/OpenVisualCloud/Smart-City-Sample.git
cd Smart-City-Sample
git checkout 577d483635856c1fa3ff0fbc051c6408af725712
#build the SmartCity images
mkdir build
cd build
cmake -DNOFFICES=1 -DREGISTRY=172.16.182.96:30003/library 
./deployment/kubernetes/helm/build.sh    
make
make tunnels  

cd Smart-City-Sample/deployment/kubernetes/helm
# Set cloud host IP in two places !!!!
CLOUDHOST=10.240.224.149
YAMLTMP=/root/code/EMCO_TEST_1204/Smart-City-Sample/deployment/kubernetes/helm/smtc/values.yaml
sed -i -e "s/    cloudHost:.*/    cloudHost: \"$CLOUDHOST\"/g" -e "s/cloudWebExternalIP:.*/cloudWebExternalIP: \"$CLOUDHOST\"/g" $YAMLTMP

cp -r smtc smtc_edge
rm smtc_edge/templates/cloud* -rf
cp -r smtc smtc_cloud
rm smtc_cloud/templates/* -rf
cp smtc/templates/*.tpl smtc_cloud/templates/
cp smtc/templates/cloud* smtc_cloud/templates/

tar -zcvf smtc_edge_helmchart.tar.gz smtc_edge
tar -zcvf smtc_cloud_helmchart.tar.gz smtc_cloud

mv -f smtc_edge_helmchart.tar.gz /opt
mv -f smtc_cloud_helmchart.tar.gz /opt

tar -tvf /opt/smtc_edge_helmchart.tar.gz
tar -tvf /opt/smtc_cloud_helmchart.tar.gz

# build profiles for 07_apps_profiles.yaml
cd $x_test/test_plans/ned/integration/ts_resources/ts29_files
# tar -zcvf smtc_edge_profile.tar.gz profile
# tar -zcvf smtc_cloud_profile.tar.gz profile
# cp smtc_edge_profile.tar.gz  smtc_cloud_profile.tar.gz /opt

tar -zczf smtc_edge_profile.tar.gz -C ./profile manifest.yaml override_values.yaml
tar -zcvf smtc_cloud_profile.tar.gz -C ./profile manifest.yaml override_values.yaml

tar -tvf smtc_edge_profile.tar.gz
tar -tvf smtc_cloud_profile.tar.gz

cp smtc_edge_profile.tar.gz  smtc_cloud_profile.tar.gz /opt