source output_alert_date.sh
source output_row_count.sh
source output_update_time.sh

sudo rm output/union.txt
cat output/* >> output/union.txt
