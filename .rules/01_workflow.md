This is the workflow that you'll follow for EVERY new session.

DO NOT, UNDER ANY CIRCUMSTANCES, do anything BUT this workflow. Not even for
emergencies.

AGENTS ARE NEVER ALLOWED TO MODIFY THIS FILE. It must always be modified by a
human. If a modification is needed, **STOP** and ask the human to perform the
modification before continuing.

## Workflow

0. Ensure that the `/browser` skill is ready to be used (install anything
   required to make it work; confirm paths to applications; etc.)
1. Ask for the name of the employer.
2. Ask for the title of the role.
     - **IMPORTANT**: This is ALWAYS a single sentence and fewer than seven
       words. REJECT anything that doesn't meet this criteria and keep asking me
       until I provide a valid role.
3. Ask for a copy of the job description. This might be long.
4. Ask for the URL to the job application.
5. Outline my job preferences in `02_job_preferences.md` and ask me whether I
   want to change any of them ("yes"/"y" for yes; "no"/"n" for no; case
   insensitive; "no" is the default answer).

   If I say "yes", ask me what I'd like to change. After the change is made,
   re-run this step until I say "no".

   > **NOTE**: DO NOT modify `02_job_preferences.md` with anything OTHER than
   > what I provide IF AND ONLY IF I SAY "no".
5. Analyze the experience and skills I have outlined in the
   `resumes/consulting.yaml` and `resumes/eng.yaml` resume partials to tell me
   whether I'm a fit for the role based solely on the job description.

   (Make sure to consider ALL previous commits to these files to get more
   information about past jobs.)

   Tell me whether you think I'm a WEAK, MEDIUM, or STRONG fit or not and why
   (three bullet points).

   Ask me if I want to continue generating a resume partial ("yes"/"y" for yes;
   "no"/"n" for no; case insensitive; "yes" is the default answer).

   Exit immediately if I say "no."
6. Use the `/browser` skill to deeply-research the requirements of the role by
   doing the following:
    - Search for reviews of the employer on Glassdoor and TeamBlind based on the
      role and company.
    - Search AT MOST TEN LinkedIn profiles of people with this role or company
      name in their history. Summarize their experience and use that in your
      research.
      - If any of these LinkedIn profiles have GitHub accounts attached to them,
        visit their GitHub profiles and summarize the projects in their repos
        and contributions from their PRs.
    - Use the job application URL to determine the ATS the employer is using for
      this application and analyze gaps in my resume that can help make me a
      better fit.
    - **IMPORTANT**: If the employer looks like a recruitment agency or sourcing
      firm, **STOP** and ask me if you should continue analysis.
7. Create a resume partial named `specific-$EMPLOYER.example.yaml` (replace `$EMPLOYER`
   with the employer provided in step 1) that you think will be a perfect fit
   for the role.

   Rules:
   - Use `consulting.yaml` as the basis for your resume partial if the role is a
     consulting/presales role or `eng.yaml` if the role feels more like an
     engineering role.
   - Use the same `company`, `location`, `dates` and `title` fields as the
     resume that you choose as your basis. 
   - Make sure that the `highlights` you add for each job experience object
     consider the information `title` and `company` fields! For example, my time
     as a `Federal Presales Engineer` at `Wiz` should have `highlights`
     corresponding to a presales engineer or solutions architect, not an SRE.
   - Feel free to add whatever `skill` objects you think will make the resume
     stand out. Make sure to stick to the schema as implemented by the basis
     resume chosen.
8. Save a transcript of this session to `.research/specific-company-$DATE.yaml`
   where `$DATE` is the time that you finished your analysis as a Unix
   timestamp.

## Example Workflow

```
➡️  Tell me the name of the employer your applying at: Awesome Company

➡️  Now tell me the role that you're applying for: Senior Platform Engineer

➡️  Paste the URL to the job application: https://example.jobs/foo/bar/baz

➡️  Paste the job description below. Press ENTER twice when finished:

# Copied from a LinkedIn Jobs post; this is just an example.
 About the job

Overview

    Hybrid-remote opportunity for candidates geographically located within an hour drive of Houston, Texas with a willingness to work on-site one to two days per week.

We’re looking for an exceptional Senior Solutions Architect with an expertise in Datacenter Infrastructure Presales to support enterprise and upper mid-market customers by designing modern data center solutions across compute, storage, virtualization, and hybrid infrastructure platforms. If you know how to inspire a diverse team, partner well, and operate as part of a larger team, you are who are looking for.

As a Senior Solutions Architect, you will support enterprise and upper mid-market customers by designing modern data center solutions across compute, storage, virtualization, and hybrid infrastructure platforms. This role operates as a territory-aligned architect, partnering closely with Account Executives to shape opportunities, lead technical discovery, and develop architectures that drive customer outcomes.

# NOTE: You don't have to use the status below; get creative!
✨ Analyzing compatibility with the role...

# Fit levels: STRONG, MEDIUM, WEAK.
✅  It looks like you're a MEDIUM fit for this role. Here's why:

* Reason 1
* Reason 2
* Reason 3

➡️  Type "yes" or "y" if you'd like me to continue creating your resume partial: yes

# NOTE: You don't have to use the status below; get creative!
# You can also create multiple statuses as appropriate.
✨ Researching the employer and role more deeply. This will take several minutes.
✨ Performing validations. Please wait.

➡️  Your resume partial is ready. Run `PERSONA=specific-awesome_company make
test` to view it.

📝 Summary
=================

💁 Role Info
----------------

Here's a quick summary of the perfect candidate for this role:

# Insert a one paragraph summary of the perfect candidate based on the
information retrieved during analysis

These people on LinkedIn are currently doing the role; you might want to check
them out:

# List LinkedIn profiles; DO NOT PRINT NAMES

🤖 ATS Summary
---------------

It looks like they're using the $ATS_NAME ATS to triage applications. Here are
some recommendations to help you get through their filters:

- Recommendation 1
- Recommendation 2
- Recommendation 3

📕 Sources
----------

Here are all of the sources I used in my analysis:

- Source 1
- Source 2
- ...
- Source n


🏆 Recommended Experience
-------------------------

I used the `consulting` resume partial to generate this. Here's a summary of how
it differs:

- Difference 1
- Differnece 2
- Difference 3

Here's a list of skills I added that will increase your odds of a follow-up:

- title: Foo
  items:
  - Bar
  - Baz
  - Quux
- title: Next skill
# etc
```
