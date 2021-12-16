/* Copyright 2021 Intel Corporation
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
#include <iostream>
#include <string>
#include <memory>
#include <stdexcept>
#include <cstdio>
#include <array>
#include <unistd.h>
#include <toml.hpp>
#include "process_wo.h"

int main(int argc, char* argv[]) {

    std::string model_file;
    std::string in_image;
    std::string in_image_dir;
    std::string out_image_dir;

    if (argc < 2){
    	std::cout<< "Input image name is required as an argument!!" << std::endl;
    	std::cout<< "Proceeding to process default image : " << "test.png" << std::endl;
        in_image = "test.png";
    }else{
        in_image = argv[1];
    }
    // Read toml file
    try {
        auto config = toml::parse("config.toml");
        model_file = toml::find<std::string>(config, "model_file");
        in_image_dir = toml::find<std::string>(config, "input_image_dir");
        out_image_dir = toml::find<std::string>(config, "output_image_dir");
    }
    catch (const toml::exception& error) {
        std::cout << error.what() << std::endl;
        return 1;
    }
    catch (...) {
        std::cout<< "Unknown/internal exception happened." << std::endl;
        return 1;
    }
    // Create work order processor.
    ProcessWorkOrder process_wo(in_image_dir, out_image_dir);
    // Load Single Shot Detector (SSD) model.
    int ret = process_wo.load_model(model_file);
    if (ret != 0) {
        std::cout << "Loading Openvino SSD model failed" << std::endl;
        return 1;
    }

    std::cout<< "Start processing images: "<< in_image << std::endl;
    std::string result = process_wo.process_work_order(in_image);
    std::cout << result << std::endl;

    return 0;
}

/**
*  ProcessWorkOrder constructor.
*
*  @param in_image_dir Path where input images are kept.
*  @param out_image_dir Path where output images are kept.
*/
ProcessWorkOrder::ProcessWorkOrder(const std::string in_image_dir, 
                                   const std::string out_image_dir)
        :in_image_dir(in_image_dir),out_image_dir(out_image_dir) {  
    this->ssd = SSDObjectDetection();

}

/**
*  Load model which will be used for object detection.
*
*  @param modelFile Model file name.
*  @return 0 in case of success. Other values indicate failure.
*/
int ProcessWorkOrder::load_model(const std::string &modelFile) {
    int ret = ssd.load_model(modelFile);
    return ret;
}    

/**
*  Run openvino inference.
*
*  @param in_image_name Input image name.
*  @return output message as string.
*/
std::string ProcessWorkOrder::process_work_order(std::string &in_image_name) {
    
    std::string output;
    std::string in_image_path = in_image_dir + in_image_name;
    
    // Create output bmp image name.
    size_t dot_index = in_image_name.find_last_of(".");
    std::string out_image_name = in_image_name.substr(0, dot_index) + ".bmp";
    std::string out_image_path = out_image_dir + out_image_name;

    int ret = ssd.object_detection(in_image_path, out_image_path);
    
    if(ret == 0) {
        output = "Openvino Success: Generated output file: " + out_image_name;
    } else {
        output = "Openvino Error: Could not execute OpenVino inference";
    }
    return output;

}
