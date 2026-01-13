#!/usr/bin/env bash
# Process all papers in the queue automatically

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENT_ID="agent_$(date +%s)"

cd "$SCRIPT_DIR"

echo "🤖 Starting batch processing with agent: $AGENT_ID"
echo "📊 Checking queue status..."

# Count remaining papers
REMAINING=$(jq '.remaining' .processing_queue.json)
echo "📄 Papers remaining: $REMAINING"

if [ "$REMAINING" -eq 0 ]; then
    echo "✅ All papers have been processed!"
    exit 0
fi

# Process papers one by one
COUNTER=1
while [ "$COUNTER" -le "$REMAINING" ]; do
    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo "📚 Processing paper $COUNTER of $REMAINING"
    echo "════════════════════════════════════════════════════════════"
    
    # Claim next paper
    PAPER_INFO=$(bash process_next_paper.sh "$AGENT_ID" 2>&1)
    
    if echo "$PAPER_INFO" | grep -q "No more papers to process"; then
        echo "✅ Queue is empty - all papers processed!"
        break
    fi
    
    # Extract paper details
    PAPER_ID=$(echo "$PAPER_INFO" | grep "ID:" | cut -d: -f2 | xargs)
    PDF_PATH=$(echo "$PAPER_INFO" | grep "Resolved:" | cut -d: -f2- | xargs)
    OUTPUT_FILE=$(echo "$PAPER_INFO" | grep "Output:" | cut -d: -f2 | xargs)
    
    if [ -z "$PAPER_ID" ]; then
        echo "❌ Failed to extract paper ID, skipping..."
        COUNTER=$((COUNTER + 1))
        continue
    fi
    
    echo "📄 Paper ID: $PAPER_ID"
    echo "📁 PDF: $PDF_PATH"
    echo "📝 Output: $OUTPUT_FILE"
    
    # Check if PDF exists
    if [ ! -f "$PDF_PATH" ]; then
        echo "❌ PDF not found, marking as failed..."
        # Mark as failed and continue
        COUNTER=$((COUNTER + 1))
        continue
    fi
    
    echo "⏳ Extracting text from PDF..."
    TEMP_TXT="/tmp/paper_${PAPER_ID}.txt"
    pdftotext "$PDF_PATH" "$TEMP_TXT" 2>/dev/null || {
        echo "❌ Failed to extract PDF text, marking as failed..."
        COUNTER=$((COUNTER + 1))
        continue
    }
    
    LINE_COUNT=$(wc -l < "$TEMP_TXT")
    echo "✅ Extracted $LINE_COUNT lines"
    
    echo "⏸️  Ready for Copilot to process..."
    echo ""
    echo "🎯 Next steps for Copilot:"
    echo "   1. Read extracted text from: $TEMP_TXT"
    echo "   2. Create summary at: $OUTPUT_FILE"
    echo "   3. Run completion command when done"
    echo ""
    echo "Press ENTER when Copilot has finished processing this paper..."
    read -r
    
    # Mark as complete
    echo "✅ Marking paper as complete..."
    bash process_next_paper.sh "$AGENT_ID" --complete "$PAPER_ID"
    
    COUNTER=$((COUNTER + 1))
done

echo ""
echo "════════════════════════════════════════════════════════════"
echo "🎉 Batch processing complete!"
echo "════════════════════════════════════════════════════════════"

# Final status
FINAL_REMAINING=$(jq '.remaining' .processing_queue.json)
FINAL_PROCESSED=$(jq '.processed' .processing_queue.json)
echo "📊 Final status:"
echo "   ✅ Processed: $FINAL_PROCESSED"
echo "   📄 Remaining: $FINAL_REMAINING"
