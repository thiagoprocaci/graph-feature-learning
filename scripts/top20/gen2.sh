set -x

CURR_DIR=$(pwd)

DIM=10
while [ $DIM -le 30 ]
do


#echo "$CURR_DIR"


OUTPUT_DIR="/home/thiago/Área de Trabalho/tbp/workspace/node2vec/scripts/top20"
BIOLOGY_CLASS_FILE="biology.class.csv"
CHEMISTRY_CLASS_FILE="chemistry.class.csv"

COMMUNITY="biology"

OUTPUT_FILE="$OUTPUT_DIR/$COMMUNITY-ahead-when-necessary-dim.$DIM"
OUTPUT_FILE_EMD="$OUTPUT_FILE.emd"
OUTPUT_FILE_AUC="$OUTPUT_FILE.auc"


Rscript biology-ml.R "$OUTPUT_FILE_AUC" "$OUTPUT_FILE_EMD" "$BIOLOGY_CLASS_FILE" "$DIM"

COMMUNITY="chemistry"

OUTPUT_FILE="$OUTPUT_DIR/$COMMUNITY-ahead-when-necessary-dim.$DIM"
OUTPUT_FILE_EMD="$OUTPUT_FILE.emd"
OUTPUT_FILE_AUC="$OUTPUT_FILE.auc"


Rscript biology-ml.R "$OUTPUT_FILE_AUC" "$OUTPUT_FILE_EMD" "$CHEMISTRY_CLASS_FILE" "$DIM"


DIM=$((DIM + 5))

done