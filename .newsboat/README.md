# 📰 Newsboat RSS Reader Guide

## 🤔 What is Newsboat?

Newsboat is a lightweight, terminal-based RSS/Atom feed reader. It's fast, keyboard-driven, and highly customizable, making it perfect for efficiently managing and reading multiple news feeds without leaving the command line.

**✨ Key Benefits:**

- ⚡ Minimal resource usage
- ⌨️ Keyboard-centric navigation
- 🔧 Scriptable and extensible
- 📴 Offline reading capability
- 🎯 Powerful filtering and organization

## 🎮 Basic Navigation & Keybindings

### 📋 Feed List View

- `j/k` or `↓/↑` - Navigate between feeds
- `Enter` - Open selected feed
- `r` - 🔄 Reload current feed
- `R` - 🔄 Reload all feeds
- `q` - ❌ Quit/go back
- `/` - 🔍 Search feeds
- `?` - ❓ Show help

### 📄 Article List View

- `j/k` or `↓/↑` - Navigate between articles
- `Enter` - Open article in pager
- `o` - 🌐 Open article in web browser
- `n` - ⏭️ Jump to next unread article
- `^B` - 🔖 Bookmark current article
- `q` - ⬅️ Return to feed list

### 📖 Article Pager

- `j/k` or `↓/↑` - Scroll article
- `o` - 🌐 Open in browser
- `q` - ❌ Close pager

## ⚙️ Configuration

Configuration files are stored in `~/.newsboat/`:

### 📝 config file

Main configuration file controlling newsboat behavior:

```bash
browser "firefox %u"              # Default browser
bookmark-cmd ~/.newsboat/bookmark.sh  # Bookmark script
bookmark-interactive yes          # Prompt for bookmark details

# Auto-refresh settings
auto-reload yes                   # Enable automatic reloading
reload-time 60                    # Reload every 60 minutes
refresh-on-startup yes            # Refresh when starting
reload-threads 8                  # Parallel feed fetching

# Article retention
max-items 0                       # Keep all articles (0 = unlimited)
keep-articles-days 180            # Keep articles for 180 days
cleanup-on-quit yes               # Clean up old articles on exit
```

### 📑 urls file

Feed subscriptions with organization:

```bash
# Feed format: URL "Title" tags flags

# Query feeds (virtual feeds based on tags)
"query:=? Blogs:tags # \"blog\""
"query:=? News:tags # \"news\""

# Regular feeds
https://example.com/feed.xml "~Blog Name" "blog" "!"
```

**📌 URL File Syntax:**

- `~` prefix - 🙈 Hidden from main list (shown only in query feeds)
- `"blog"` - 🏷️ Tag for organization
- `!` - ⭐ Mark as "always unread" (optional)

## 🗂️ Feed Organization with Query Feeds

Query feeds create virtual categories by filtering feeds with specific tags:

1. **📚 Blogs Category** - Shows all feeds tagged with "blog"

   ```
   "query:📚 Blogs:tags # \"blog\""
   ```

2. **📰 News Category** - Shows all feeds tagged with "news"
   ```
   "query:📰 News:tags # \"news\""
   ```

This keeps your main feed list clean while organizing feeds by topic.

## 🔄 Common Workflows

### ➕ Adding a New Feed

1. Edit `~/.newsboat/urls`:
   ```bash
   https://newsite.com/rss "~Site Name" "category" "!"
   ```
2. Reload newsboat with `R`

### 📖 Daily Reading Routine

1. Start newsboat: `newsboat`
2. Press `R` to reload all feeds
3. Navigate to query feed (📚 Blogs or 📰 News)
4. Press `Enter` to view articles
5. Use `n` to jump between unread articles
6. Press `o` to open interesting articles in browser
7. Press `^B` to bookmark articles for later

### 🎯 Managing Subscriptions

- 🏷️ Organize feeds with tags in the urls file
- 🙈 Use `~` prefix to hide individual feeds
- 📂 Create query feeds for topic-based browsing
- ⭐ Use `!` flag for feeds you want to track but not mark as read

## 🔖 Bookmarking

Press `^B` on any article to save it using the bookmark script (`~/.newsboat/bookmark.sh`). Bookmarks are stored in `~/.newsboat/bookmarks.txt` for later reference.

## 💡 Tips

- ⏰ Use `reload-time` to automatically stay up-to-date
- 📊 Tags and query feeds scale well with many subscriptions
- 🧹 The `keep-articles-days` setting prevents database bloat
- ⚡ Increase `reload-threads` for faster bulk refreshes
- 💾 Use `max-items 0` to keep full article history

## 📚 Resources

- 🌐 Official documentation: https://newsboat.org/
- 📖 Configuration options: `man newsboat`
- ⌨️ Key bindings reference: Press `?` in newsboat
