#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check arguments
if [ "$#" -ne 2 ]; then
    echo -e "${RED}Usage: $0 <type> <name>${NC}"
    echo -e "  type: system or user"
    echo -e "  name: migration name (e.g., install_nodejs)"
    echo -e "\nExample: $0 system install_nodejs"
    exit 1
fi

TYPE="$1"
NAME="$2"

# Validate type
if [[ "$TYPE" != "system" ]] && [[ "$TYPE" != "user" ]]; then
    echo -e "${RED}Error: Type must be 'system' or 'user'${NC}"
    exit 1
fi

# Generate timestamp
TIMESTAMP=$(date +%s)

# Create migrations directory structure if it doesn't exist
SCRIPT_DIR="$(dirname "$0")"
mkdir -p "$SCRIPT_DIR/$TYPE"

# Generate filename
FILENAME="$SCRIPT_DIR/$TYPE/${TIMESTAMP}_${NAME}.sh"

# Create migration file with template
cat > "$FILENAME" << 'EOF'
#!/bin/bash
set -e

# Migration: MIGRATION_NAME
# Type: MIGRATION_TYPE
# Created: MIGRATION_DATE

echo "Running migration: MIGRATION_NAME"

#############################################
# Add your migration commands below
#############################################



#############################################
# End of migration commands
#############################################

echo "✓ Migration completed: MIGRATION_NAME"
EOF

# Replace placeholders
sed -i.bak "s/MIGRATION_NAME/$NAME/g" "$FILENAME"
sed -i.bak "s/MIGRATION_TYPE/$TYPE/g" "$FILENAME"
sed -i.bak "s/MIGRATION_DATE/$(date)/g" "$FILENAME"
rm "${FILENAME}.bak"

# Make executable
chmod +x "$FILENAME"

echo -e "${GREEN}✓ Created migration: $FILENAME${NC}"
echo -e "${YELLOW}Edit the file to add your migration commands${NC}"

# Open in default editor if EDITOR is set
if [ -n "$EDITOR" ]; then
    $EDITOR "$FILENAME"
fi