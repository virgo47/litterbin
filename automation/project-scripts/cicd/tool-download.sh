#@IgnoreInspection BashAddShebang
# shellcheck shell=bash disable=SC2034,SC1090,SC2164
#
# Downloads the $ARCHIVE_URL in $TOOL_BASE_DIR and if $ARCHIVE_SUM is set,
# it uses $ARCHIVE_SUM_APP to check the archive checksum.
# After that it unpacks the archive with $UNPACK_APP and optional $ARCHIVE_UNPACK_APP_TAIL_OPTS.
# If everything is OK, temporary archive is removed, otherwise kept
# (but should be removed before trying again, as suggested in the message).
#
# Everything is executed with $TOOL_BASE_DIR as working directory internally,
# but working directory is restored afterwards.
#
# Input variable list:
# TOOL_BASE_DIR - parent directory for downloaded tool, will be created if necessary
# ARCHIVE_URL - archive URL
# ARCHIVE_SUM - value of expected checksum
# ARCHIVE_SUM_APP - command to check the checksum (with options if necessary)
# UNPACK_APP - command to unpack the application (with any options before the archive name)
# ARCHIVE_UNPACK_APP_TAIL_OPTS - optional options for unpack command following the archive name

(
	mkdir -p "$TOOL_BASE_DIR"
	cd "$TOOL_BASE_DIR"
	TMP_ARCHIVE="archive.tmp"

	echo "Downloading from: $ARCHIVE_URL"
	curl -fsL -C - -o "$TMP_ARCHIVE" "$ARCHIVE_URL"

	if [[ -n "${ARCHIVE_SUM:-}" ]]; then
		# ARCHIVE_SUM_APP must not be quoted, we may need options
		FILE_SUM="$($ARCHIVE_SUM_APP "$TMP_ARCHIVE" | cut -d' ' -f1)"
		if [[ "$ARCHIVE_SUM" != "$FILE_SUM" ]]; then
			echo -e "\nChecksum failed for downloaded archive\nExpected: $ARCHIVE_SUM\nDownload: $FILE_SUM\n"
			echo "Keeping invalid $PWD/$TMP_ARCHIVE for inspection. REMOVE IT BEFORE TRYING AGAIN!"
			exit 1
		fi
	fi
	# UNPACK_APP must not be quoted, we may need options
	$UNPACK_APP "$TMP_ARCHIVE" ${ARCHIVE_UNPACK_APP_TAIL_OPTS:-}
	rm "$TMP_ARCHIVE"
)