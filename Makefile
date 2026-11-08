all:
	@echo -e "Options\n=======\n"
	@echo "install - Install the script to /usr/local/bin/gentoo_auto_update"
	@echo "feature - Add features to the script via patches"
	@echo "uninstall - Remove script from /usr/local/bin"

check:
	@bash -c "exit"
	@emerge --version > /dev/null

install: check
	cp -f gentoo_auto_update.sh /usr/local/bin/gentoo_auto_update
	chmod 755 /usr/local/bin/gentoo_auto_update

feature:
	@echo -e "FEATURES\n========\n"
	@echo "feature-html - Generate a html file with logs"
	@echo "feature-discord - Add discord webhook functionality to the script"
	@echo "feature-all - Patch all features to the script"

feature-html:
	git apply patches/feature_html_file.diff

feature-discord:
	git apply patches/feature_discord_webhook.diff
	git apply patches/feature_check.diff

feature-all:
	git apply patches/feature_all.diff

uninstall:
	rm -f /usr/local/bin/gentoo_auto_update
	