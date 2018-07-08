set -x

CURR_DIR=$(pwd)


#echo "$CURR_DIR"

COMMUNITY="ba.8937"
DIM=10
MY_WALK="/home/thiago/Área de Trabalho/tbp/workspace/node2vec/src/MyWalk.py"
EDGE_LIST_BIOLOGY="/home/thiago/Área de Trabalho/tbp/workspace/node2vec/scripts/barabasi/$COMMUNITY.edgelist.csv"
OUTPUT_DIR="/home/thiago/Área de Trabalho/tbp/workspace/node2vec/scripts/"

BIOLOGY_CLASS_FILE="$COMMUNITY.class.csv"



OUTPUT_FILE="$OUTPUT_DIR/$COMMUNITY-ahead-when-necessary-dim.$DIM"
OUTPUT_FILE_EMD="$OUTPUT_FILE.emd"
OUTPUT_FILE_AUC="$OUTPUT_FILE.auc"

rm "$OUTPUT_FILE_EMD"

python2 "$MY_WALK" --input="$EDGE_LIST_BIOLOGY" --output="$OUTPUT_FILE_EMD" --dimensions="$DIM"

sed -i '1d' "$OUTPUT_FILE_EMD"

Rscript biology-ml.R "$OUTPUT_FILE_AUC" "$OUTPUT_FILE_EMD" "$BIOLOGY_CLASS_FILE" "$DIM"


mv ../*.auc .
mv ../*.emd .