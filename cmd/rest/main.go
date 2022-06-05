package main

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

var msg struct {
	Name    string `json:"range"`
	Message string
	Number  int
}

func main() {
	router := gin.Default()
	router.GET("/range2/:range", getRange1)
	router.GET("/range2/range1/:range", getRange2)
	router.GET("/health", getHealth)
	err := router.Run(":8080")
	if err != nil {
		return
	}
}

func getRange1(c *gin.Context) {
	msg.Name = c.Params.ByName("range")
	msg.Message = "Range 2"
	msg.Number = 123
	c.IndentedJSON(http.StatusOK, msg)
}

func getRange2(c *gin.Context) {
	range2 := "https://alb-153017194.us-east-1.elb.amazonaws.com/range1/"
	param := c.Params.ByName("range")
	url := fmt.Sprintf("%s%s", range2, param)
	response, err := http.Get(url)

	if err != nil {
		fmt.Print(err.Error())
		os.Exit(1)
	}

	responseData, err := ioutil.ReadAll(response.Body)
	if err != nil {
		log.Fatal(err)
	}
	c.String(http.StatusOK, string(responseData))
}

func getHealth(c *gin.Context) {
	msg.Name = "Health Check"
	msg.Message = "Health Check"
	msg.Number = 123
	c.JSON(http.StatusOK, msg)
}
