+++
date = '2026-08-10T19:15:49-05:00'
title = 'Spacelift'
+++

## Spacelift Basics
**Issues that we face**
- Multiple PR and the lock state
- Access control limitations

### What is Spacelift?
- CI/CD tool specifically for IaC
- Preview plans before applying PRs
- Access control policies
- Manage IaC State
- Drift detection

**Concepts:**
- Stacks: Repo + State + Env variable
- Policy: Uses Open Policy Agent
	- Login
	- Access
	- Approval
	- Runts and Tasks
	- Routing and filtering
	- etc

### Create your First Stack
Detect changes on `GitHub` and start a `Run`

### Environment Variables
How do we give our runner?
Using `Environment` tab

### Trigger a Run
Select `trigger`
- We can Discard or confirm

### Viewing Resources
we can see the outputs and also (for example) the instance

### Concurrent Runs & Amp Queued State
If there is a simultaneous PR, `Spacelift` posts a message saying it is stuck due to an specific commit.

### Tasks
You can run individual commands from here

### Policies
- `Plan Policy`
```json
package spacelift
deny["Policy was denied"] {
  instance := input.terraform.resource_change[_].change.after.instance_type
  instance != sanitized("t2.micro")
}
sample { true }
```

- `sample` input so it can actually validate in a separate `sample input` window

### Mounted Files
Mount a file that is going to have all your variables
You provide the path
`/mnt/workspace/source`
We can add the `terraform.tfvars`

