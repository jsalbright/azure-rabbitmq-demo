What is this?
==============

This will create a RHEL 7.3 Azure Managed Disk image with RabbitMQ installed.
Some sample `inspec` tests are also provided.

How do I use it?
================

You will need to install Docker to use this Makefile.

1. Clone this repository.
2. Create your .env: `cp .env.example .env`
3. Populate your `.env` with real values. See [this](https://www.packer.io/docs/builders/azure-setup.html) document for information on how to get started.
4. Ensure that your code is valid: `make lint`
5. Build your image: `make build`

Additional Notes
================

This `Makefile` writes a build number to your working directory that is prefixed onto any images that you create.
You might want to consider using tags for future images, and you also might want to consider
having Jenkins or another version locking system manage versions for you.
