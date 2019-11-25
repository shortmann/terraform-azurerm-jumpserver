![Terraform Version](https://img.shields.io/badge/terraform-0.12.12-blue.svg)


terraform-azurerm-jumpserver
================================================================

A terraform module which creates a jumpserver

Provider
--------

This module is written for azurerm

Layout
------

```sh
├── examples
│   └── jumpserver-singlenode
│       ├── README.md
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── modules
│   └── jumpserver
│       ├── README.md
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
└── test
    └── jumpserver_singlenode_test.go
```

### examples
Examples are terraform scripts which execute the modules. They are used by tests.

### modules
jumpserver
  
### test
Go tests for your terraform module

Test
----
Tests are written for [terratest](https://github.com/gruntwork-io/terratest).
The installation of golang is requiered.

Create a go.mod file. Inside the test folder run.
```sh
go mod init jumpserver
```

Download terratest.
```sh
go mod tidy
```

Then run the tests
```sh
go test -v -timeout 90m .
```
<!-- ### install golang -->

Author
------
Kai Kahllund <kai.kahllund@akra.de>

License
-------
MIT