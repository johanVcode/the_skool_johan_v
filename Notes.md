# My Notes
## The setup
* Created repo the_skool_johan_v (kept johan_v instead of full name, for privacy)
* .gitignore: secrets (.env, *.env), nano *.save, OS files. Removed the Vim section because its pattern could match .sql files
* Per-repo deploy key + SSH alias github-the_skool_johan_v, write access ticked, tested with ssh -T
* Added IdentitiesOnly yes so each alias only uses its own key
* git init → commit → branch -M main → remote add origin → push -u
* added 00_scratch_data.sql to .gitignore (LLM suggested i keep it intentionally ignored rather then showing every SQL command that fails, keep it clean)

## Data
* Downloaded "resultat ansökningsomgång 2025 from MYH
* Kept original untouched, made a working copy instead with only tabell 3 because i prefer keeping the original incase something happens
* Removed rows 1-6 (extra title text) so only header shows now, i just prefer clean data.
* Checked the bottoom for footnotes: there was none. (the LLM suggested i did this, so adding this to my checks)
* 1185 rows while 1 is just the header, so in total 1184 rows of data.
* moved the files with scp protokol from powershell.
* called the whole table myh_tabell_2025 for easy connection with sql command lines
* F5 i can run the data and check my scratch draft and if it works i can drop it in 02_clean_data.sql
* Learned from the dlorg class: `SELECT column FROM table` picks one column by its name,
  e.g. `SELECT UTBILDNINGSOMRÅDE FROM MYH_TABELL_2025`. (In the CSV it was a header;
  in the database the same thing is called a column.)
* tought could be a good idea to keep every header as a select, was a lot of writing and copy pasting in the end.
* used the LLM to write the rest for me as to get it fast
* DROP TABLE IF EXISTS: been using it mostly out of habit but never understood it, so googled and
  asked the LLM. DROP wipes the old table so the scripts can be rerun from scratch (re-runnable).
  IF EXISTS stops an error on the very first run, when there's no table yet.
* Bigger picture: the original CSV is never touched. The scripts (01 load → 02 clean) are a
  trail of instructions that rebuild the cleaned table from the raw data (reproducibility).

## Oracle infra (dataset)
* moved the setup out of SQL_1 into its own folder instead to organize and link to diffrent projects.
* re-pointed orac symlink.
* fresh volume oracle_oradata, removed the old one. Password is now in one place.
* Projects moved to ~/projects
* Learned that oracles sqlcl, has a name for its connection called /scripts to show whole projects so for example ~/projects (on the VM) = /scripts (inside the container) 
to show where i keep all my projects (OBS: /scripts is not a folder nor a temp folder, just a marker), will later be changed to specific folder to go a clean 0 trust baseline again, mostly for frictionless testing.
* My first connect failed with 'orac ~/oracle/hello.pls' and error code ORA-12514. Because oracle needed time to start up and 
sometimes it does checks before everything is set, so it connected to early. 
