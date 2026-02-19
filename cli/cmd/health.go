package cmd

import (
	"fmt"
	"io"
	"net/http"
	"os"

	"github.com/spf13/cobra"
)

var healthCmd = &cobra.Command{
	Use:   "health",
	Short: "Check the health of the Python microservice",
	Run: func(cmd *cobra.Command, args []string) {
		// Default to localhost for local testing, but allow environment variable override for Docker/K8s
		apiURL := os.Getenv("API_URL")
		if apiURL == "" {
			apiURL = "http://localhost:8000"
		}

		endpoint := fmt.Sprintf("%s/health", apiURL)

		resp, err := http.Get(endpoint)
		if err != nil {
			fmt.Printf("Error reaching service: %v\n", err)
			os.Exit(1)
		}
		defer resp.Body.Close()

		body, err := io.ReadAll(resp.Body)
		if err != nil {
			fmt.Printf("Error reading response: %v\n", err)
			os.Exit(1)
		}

		fmt.Printf("Service Status: %s\n", string(body))
	},
}

func init() {
	// Register the 'health' command as a child of the root command.
	rootCmd.AddCommand(healthCmd)
}