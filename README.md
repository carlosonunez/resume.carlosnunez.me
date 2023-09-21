# resume.carlosnunez.me

Generates resumes from a convenient YAML-based DSL. A fine example of YAML
engineering. 👷🏾

![](./assets/screenshot.png|width=200)

## Features

- Automatic deployment into AWS at `resume.$YOUR_DOMAIN`.
- Super lightweight YAML-based DSL for expressing your entire life in resume
  form with Markdown
- Beautiful website-based resumes, powered by Hugo
- Generate the perfect resume for a specific employer with "Personas"
- Keep your resume updates on the DL with "WIP Resumes"

## How resumes are made

> Feel free to fork this repo and create your own resumes, if you wish!

### Prerequisites

- Docker and Docker Compose
- `make`

### Decrypting environment config

First, I'd decrypt my dotenv which configures sensitive data, like
Terraform remote state buckets and AWS configuration.

### Adding a new resume persona

1. Add a new resume "persona" to the `resume` block within `config.yaml`:

  ```yaml
  resume:
  - name: new_persona
    yaml: persona
    record: example
  ```

  Based on the default config [at this time of
  writing](https://github.com/carlosonunez/resume.carlosnunez.me/blob/main/config.yaml),
  I would expect this to create a resume that's viewable at
  `https://example.resume.carlosnunez.me`.

2. Create a new resume YAML in the `resumes` folder from the example
   provided that's named after the `resume.yaml` property above:

   ```sh
   cp ./resumes/example.yaml ./resumes/persona.yaml
   ```

   But since my default persona in this config is `consulting`, I'll
   likely just copy from that file to save time:

   ```sh
   cp ./resumes/consulting.yaml ./resumes/persona.yaml
   ```

### Modifying my resume

Once I've added my new resume (or if I'm modifying an existing one),
I'll open up `./resumes/${RESUME_TO_CHANGE}.yaml` and modify as needed.

### Deploying

To deploy, I'll commit my changes and push them up to GitHub. This will
trigger [CI](./.github/workflows/main.yml), which will handle rendering
resume assets and pushing them up to AWS.

For local deployments, I'll run:

```sh
ENV_PASSWORD=passphrase ./scripts/deploy
```

just like CI does.

## Additional Features

### WIP Resumes

WIP Resumes allow you to update a resume confidentially while maintaining a
public resume in GitHub and online.

This is useful for:

- People who are paranoid about employers finding out that they're keeping their
  experience updated
- Employers who are paranoid about employees keeping their experience updated

To use this feature:

1. Create a new resume at `resumes/wip.yaml`. This file is ignored by Git and
   will never be committted.
2. Encrypt the resume with GPG:

   ```sh
   RESUME_PASSWORD=passphrase ./scripts/encrypt_wip_resume.sh
   ```

   > ✅ Keep `passphrase` somewhere safe! You won't be able to
   > recover your WIP resume if you lose it!

3. When you're ready to update the WIP resume again, decrypt it:

   ```sh
   RESUME_PASSWORD=passphrase ./scripts/decrypt_wip_resume.sh
   ```
