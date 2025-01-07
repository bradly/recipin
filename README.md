# Recipin

Private recipe bookmarking. 
Join one or run your own.

![Screenshot](https://github.com/bradly/recipin/blob/main/public/chili.png?raw=true)

## Features

- **Clean Interface**: Minimal design with basic CSS and no JavaScript
- **Recipe Extraction**: Automatically parse and save recipes in structured data
- **Ingredient Parsing**: Uses natural language processing to break down ingredient text
- **Privacy-Focused**: No ads, tracking, AI, or social networking
- **Self-Hosted**: Run your own instance or join an existing one

## Technologies

- **Backend**: Ruby on Rails
- **Frontend**: No~de~ JS, a dusting of native CSS, Haml 🤗
- **Parsing**: Python for NLP ingredient processing
- **Database**: SQLite for data storage
- **Deployment**: Kamal and Docker for VPS hosting

## Local Setup

```bash
# Clone the repository
git clone git://github.com:bradly/recipin.git
cd recipin

# Install dependencies
bundle install

# Set up the database
rails db:create db:migrate

# Start the development server
bin/dev
```

## Deployment

```bash
# Set required environment variables
export DOCKER_USERNAME=your-docker-username
export RECIPIN_IP_ADDRESS=your-server-ip

# Deploy for the first time
kamal setup
kamal deploy
```

## Authors

- [@bradly](https://www.github.com/bradly)
