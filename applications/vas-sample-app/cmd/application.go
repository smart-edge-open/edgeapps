package main

import (
  "github.com/levigross/grequests"
  "encoding/json"
  "log"
  "strings"
  "time"
)

type Source struct {
        URI string `json:"uri"`
        Type string `json:"type"`
}

type Destination struct {
        Path string `json:"path"`
        Type string `json:"type"`
        Format string `json:"format"`
}


type VASPostBody struct {
     SRCE Source `json:"source"`
     DEST Destination `json:"destination"`
}

type VASInstanceStatus struct {
	AvgFps      float64 `json:"avg_fps"`
	ElapsedTime float64 `json:"elapsed_time"`
	ID          int     `json:"id"`
	StartTime   float64 `json:"start_time"`
	State       string  `json:"state"`
}

func postVAServingRequest(vaEndPoint string, vaPipeline string) error {

   // Interface: POST /pipelines/{name}/{version} for Start new pipeline instance
   var endPointStr string 
   endPointStr = vaEndPoint+"/pipelines/"+vaPipeline
   log.Println("Starting POST Request:"+endPointStr)
   var src Source
   src.URI = "https://github.com/intel-iot-devkit/sample-videos/blob/master/bottle-detection.mp4?raw=true"
   src.Type = "uri"
   var dst Destination
   dst.Path = "/tmp/results.txt"
   dst.Type = "file"
   dst.Format = "json-lines"
   var vasPost = VASPostBody{SRCE: src, DEST: dst}
   var vasPostJson, _ = json.Marshal(vasPost)
   var vasRequestOption = &grequests.RequestOptions{}
   vasRequestOption.JSON = string(vasPostJson)
   //resp, err = grequests.Post("http://localhost:8080/pipelines/object_detection/1",vasRequestOption)
   resp, err := grequests.Post(endPointStr,vasRequestOption)
   if err != nil {
     log.Fatalln ("Post Failed with: ", err)
     return err
   }
   log.Println("Pipeline Instance Created:", resp.String())
   var instance = strings.TrimSpace(resp.String())

   // Interface: GET /pipelines/{name}/{version}/{instance_id}/status for Return pipeline instance status.
   // Loop status query until instantance completed.
   var statusResp VASInstanceStatus
   for {
     //resp, err := grequests.Get("http://localhost:8080/pipelines/object_detection/1/"+instance+"/status", nil)
     resp, err := grequests.Get(endPointStr+"/"+instance+"/status", nil)
     if err != nil {
       log.Fatalln ("Get Failed with: ", err)
       return err
     }
     log.Println(resp.String())
     resp.JSON(&statusResp)
     if statusResp.State == "COMPLETED" {
        break
     }
     time.Sleep(time.Duration(10)*time.Second)

   }
   return nil

}
