# Task 0
## The setup
* Created repo the_skool_johan_v (kept johan_v instead of full name, for privacy)
* .gitignore: secrets (.env, *.env), nano *.save, OS files. Removed the Vim section because its pattern could match .sql files
* Per-repo deploy key + SSH alias github-the_skool_johan_v, write access ticked, tested with ssh -T
* Added IdentitiesOnly yes so each alias only uses its own key
* git init → commit → branch -M main → remote add origin → push -u

## Data
* Downloaded "resultat ansökningsomgång 2025 from MYH
* Kept original untouched, made a working copy instead with only tabell 3 because i prefer keeping the original incase something happens
* Removed rows 1-6 (extra title text) so only header shows now, i just prefer clean data.
* Checked the bottoom for footnotes: there was none. (the LLM suggested i did this, so adding this to my checks)
* 1185 rows while 1 is just the header, so in total 1184 rows of data.
* moved the files with scp protokol from powershell.


## Oracle infra (dataset)
* moved the setup out of SQL_1 into its own folder instead to organize and link to diffrent projects.
* re-pointed orac symlink.
* fresh volume oracle_oradata, removed the old one. Password is now in one place.
* Projects moved to ~/projects

* Learned that oracle in full, needs a file in the folder of the project to mount everything inside its folder.
* My first connect failed with 'orac ~/oracle/hello.pls' and error code ORA-12514. Because oracle needed time to start up and 
sometimes it does checks before everything is set, so it connected to early. 
