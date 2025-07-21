package tests

import (
	"fmt"
	"math/rand"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAppDeployment(t *testing.T) {
	// t.Parallel()

	// terraformOptions := &terraform.Options{
	// 	TerraformDir: "./fixtures",

	// 	Vars: map[string]interface{}{
	// 		"name_prefix":         fmt.Sprintf("terratestapp-%d", time.Now().Unix()),
	// 		"namespace":           "msingh-terratest",
	// 		"env":                 "test",
	// 		"image":               "nginx:alpine",
	// 		"deployment_replicas": 1,
	// 	},

	// 	NoColor: true,
	// }

	// // Clean up after test
	// defer terraform.Destroy(t, terraformOptions)

	// terraform.InitAndApply(t, terraformOptions)

	t.Run("testapp", func(t *testing.T) {
		terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
			TerraformDir: "./fixtures",
			Vars: map[string]interface{}{
				"name_prefix": fmt.Sprintf("%s-%d-%d", "terratestapp", time.Now().UnixNano(), rand.Intn(1000)),
				"namespace":   "msingh-terratest",
				"env":         "test",
				"image":       "nginx:alpine",
			},
		})

		defer terraform.Destroy(t, terraformOptions)
		terraform.InitAndApply(t, terraformOptions)

		// Assertions
		t.Log("Fetching output deployment_image")
		deployment_image := terraform.Output(t, terraformOptions, "deployment_image")
		t.Logf("deployment_image=%s", deployment_image)
		assert.Equal(t, "nginx:alpine", deployment_image)

		// terraform.InitAndApplyAndIdempotent(t, terraformOptions)
	})

}
