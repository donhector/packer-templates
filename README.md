# packer-templates

Packer templates for my homelab base images

## Improvements / Experiments

- Start building from cloud images instead of ISOs
- Use `shell-local + `ansible` provisioners instead of `shell` + `ansible-local`
  This is to avoid _pulluting_ the final image as much.
  In CI environments, this approach would require installing ansible on the runner (not a problem for Github ubuntu-latest runner)
