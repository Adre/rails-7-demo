# README
## setup

A dockerised Rails 7 demo app based on the Rails 7 DHH demo.

1. `dip provision` to provision the containers
2. `dip rails s` to run the rails server
3. Go to `http://demo.localhost/posts` in your browser to go to the posts index

## useful information

- You can manually build the image with `docker compose build`
- `dip.yml` has some other useful commands
- `dip rails test` runs the test suite


## known issues

- images in the rte work, but images don't persist through provisioning
