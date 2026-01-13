#!/usr/bin/env bash
# Paper Processing Script for Parallel Execution
# Usage: ./process_next_paper.sh <agent_id>

set -e

AGENT_ID="${1:-agent_$(date +%s)}"
QUEUE_FILE="/home/alexcomas/DTU-Thesis---NSP-LLM/content/papers_markdown/.processing_queue.json"
LOCK_FILE="${QUEUE_FILE}.lock"
OUTPUT_DIR="/home/alexcomas/DTU-Thesis---NSP-LLM/content/papers_markdown"

echo "🤖 Agent: $AGENT_ID"

# Function to acquire lock with timeout
acquire_lock() {
    local timeout=30
    local elapsed=0
    
    while [ $elapsed -lt $timeout ]; do
        if mkdir "$LOCK_FILE" 2>/dev/null; then
            trap "rm -rf '$LOCK_FILE'" EXIT
            return 0
        fi
        echo "⏳ Waiting for lock... ($elapsed/$timeout)"
        sleep 1
        elapsed=$((elapsed + 1))
    done
    
    echo "❌ Failed to acquire lock after ${timeout}s"
    return 1
}

# Function to get next available paper
get_next_paper() {
    acquire_lock || exit 1
    
    # Read queue and find first pending paper
    local paper_data=$(jq -r '.papers[] | select(.status == "pending") | @json' "$QUEUE_FILE" | head -1)
    
    if [ -z "$paper_data" ]; then
        echo "✅ No more papers to process!"
        rm -rf "$LOCK_FILE"
        exit 0
    fi
    
    local paper_id=$(echo "$paper_data" | jq -r '.id')
    local pdf_path=$(echo "$paper_data" | jq -r '.pdf_path')
    local output_file=$(echo "$paper_data" | jq -r '.output_file')
    local title=$(echo "$paper_data" | jq -r '.title')
    
    # Mark paper as locked
    local timestamp=$(date -Iseconds)
    jq --arg id "$paper_id" \
       --arg agent "$AGENT_ID" \
       --arg ts "$timestamp" \
       '(.papers[] | select(.id == $id) | .status) = "processing" |
        (.papers[] | select(.id == $id) | .locked_by) = $agent |
        (.papers[] | select(.id == $id) | .locked_at) = $ts' \
       "$QUEUE_FILE" > "${QUEUE_FILE}.tmp" && mv "${QUEUE_FILE}.tmp" "$QUEUE_FILE"
    
    rm -rf "$LOCK_FILE"
    
    echo "$paper_id|$pdf_path|$output_file|$title"
}

# Function to mark paper as complete
mark_complete() {
    local paper_id="$1"
    
    acquire_lock || exit 1
    
    local timestamp=$(date -Iseconds)
    jq --arg id "$paper_id" \
       --arg ts "$timestamp" \
       '(.papers[] | select(.id == $id) | .status) = "completed" |
        (.papers[] | select(.id == $id) | .locked_by) = null |
        (.papers[] | select(.id == $id) | .locked_at) = null |
        (.papers[] | select(.id == $id) | .completed_at) = $ts |
        .processed = (.processed + 1) |
        .remaining = (.remaining - 1)' \
       "$QUEUE_FILE" > "${QUEUE_FILE}.tmp" && mv "${QUEUE_FILE}.tmp" "$QUEUE_FILE"
    
    rm -rf "$LOCK_FILE"
}

# Function to mark paper as failed
mark_failed() {
    local paper_id="$1"
    local error_msg="$2"
    
    acquire_lock || exit 1
    
    jq --arg id "$paper_id" \
       --arg error "$error_msg" \
       '(.papers[] | select(.id == $id) | .status) = "failed" |
        (.papers[] | select(.id == $id) | .locked_by) = null |
        (.papers[] | select(.id == $id) | .error) = $error' \
       "$QUEUE_FILE" > "${QUEUE_FILE}.tmp" && mv "${QUEUE_FILE}.tmp" "$QUEUE_FILE"
    
    rm -rf "$LOCK_FILE"
}

# Main processing
paper_info=$(get_next_paper)
if [ -z "$paper_info" ]; then
    exit 0
fi

IFS='|' read -r PAPER_ID PDF_PATH OUTPUT_FILE TITLE <<< "$paper_info"

echo "📄 Processing: $TITLE"
echo "   ID: $PAPER_ID"
echo "   PDF: $PDF_PATH"
echo "   Output: $OUTPUT_FILE"

# Convert Windows path to WSL if needed
if [[ "$PDF_PATH" == C:\\Users\\s233148\\* ]]; then
    PDF_PATH=$(echo "$PDF_PATH" | sed 's|C:\\Users\\s233148|/mnt/c/Users/s233148|' | sed 's|\\|/|g')
elif [[ "$PDF_PATH" == C:\\Users\\ledwo\\* ]]; then
    PDF_PATH=$(echo "$PDF_PATH" | sed 's|C:\\Users\\ledwo|/mnt/c/Users/s233148|' | sed 's|\\|/|g')
elif [[ "$PDF_PATH" == /home/ledwo/* ]]; then
    PDF_PATH=$(echo "$PDF_PATH" | sed 's|/home/ledwo/Zotero/storage|/mnt/c/Users/s233148/Zotero/storage|')
fi

echo "   Resolved: $PDF_PATH"

# Check if PDF exists
if [ ! -f "$PDF_PATH" ]; then
    echo "❌ PDF not found: $PDF_PATH"
    mark_failed "$PAPER_ID" "PDF file not found"
    exit 1
fi

echo ""
echo "🚀 Ready for Copilot to process this paper!"
echo ""
echo "Instructions for Copilot:"
echo "1. Convert PDF to markdown using: mcp_microsoft_mar_convert_to_markdown"
echo "   URI: file://$PDF_PATH"
echo "2. Create structured summary in: $OUTPUT_DIR/$OUTPUT_FILE"
echo "3. Include: Title, Authors, Year, Key Findings, Methodology, Results, Relevance to Thesis"
echo "4. After saving summary, run: ./process_next_paper.sh $AGENT_ID --complete $PAPER_ID"
echo ""

# Export for Copilot to use
export CURRENT_PAPER_ID="$PAPER_ID"
export CURRENT_PDF_PATH="$PDF_PATH"
export CURRENT_OUTPUT_FILE="$OUTPUT_FILE"
export CURRENT_TITLE="$TITLE"

# If --complete flag is passed with paper ID, mark as complete
if [ "$2" = "--complete" ] && [ -n "$3" ]; then
    mark_complete "$3"
    echo "✅ Marked $3 as complete!"
fi
