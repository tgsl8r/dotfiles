link_all:
	stow --verbose --target=$$HOME --restow */
delete_all:
	stow --verbose --target=$$HOME --delete */
init_system:
	sh ./init.sh
	stow --verbose --target=$$HOME --restow */
