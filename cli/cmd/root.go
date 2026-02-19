package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

// base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "gitops-cli",
	Short: "A CLI to interact with the Capstone infrastructure",
	Long:  `gitops-cli is a tool built to query metrics, health, and infrastructure state for the GCP DevOps Capstone project.`,
}

// Execute adds all child commands to the root command and sets flags appropriately.
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}