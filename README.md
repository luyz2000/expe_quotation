# Quotation Management System

A comprehensive web application built with Ruby on Rails for managing quotations, projects, and client relationships. This system provides a complete solution for businesses that need to generate, manage, and track quotations with materials, services, and approval workflows.

## Features

### Core Functionality
- **User Management**: Complete authentication system with roles (admin, salesperson, engineer) using Devise
- **Client Management**: Store and manage client information with contact details
- **Project Management**: Organize work into projects with responsible personnel
- **Quotation System**: Create, edit, and manage detailed quotations with multiple items
- **Material & Service Catalogs**: Maintain catalogs of materials and services with pricing
- **Quotation Items**: Add multiple items to quotations with quantities and pricing
- **Approval Workflow**: Track quotation approval status with approval/rejection functions
- **PDF Generation**: Generate professional PDF quotations
- **File Attachments**: Upload and manage files associated with quotations
- **Audit Trail**: Complete tracking of all changes with PaperTrail gem

### Technical Features
- **Responsive UI**: Bootstrap-based responsive design
- **Internationalization**: Support for multiple languages
- **Role-based Access Control**: Different permissions based on user roles
- **RESTful Architecture**: Follows Rails conventions for clean, maintainable code
- **Database Versioning**: Complete schema management with migrations
- **Test Coverage**: Comprehensive RSpec test suite

## Technologies Used

### Backend
- **Ruby**: Version 3.3.9
- **Ruby on Rails**: Version 8.0.4
- **Database**: PostgreSQL (primary) with SQLite3 as fallback
- **Authentication**: Devise for user authentication and authorization
- **File Storage**: Active Storage for file attachments
- **Background Jobs**: Solid Queue for background processing
- **Caching**: Solid Cache for performance optimization
- **Version Control**: Git with PaperTrail for change tracking

### Frontend
- **Template Engine**: HAML for clean, readable views
- **Styling**: Bootstrap 5 for responsive design and components
- **Icons**: Bootstrap Icons for visual elements
- **JavaScript**: ES6+ with Turbo for enhanced user experience

### Testing & Development
- **Testing Framework**: RSpec for comprehensive testing
- **Factories**: FactoryBot for test data generation
- **Security**: Strong parameters and CSRF protection
- **Code Quality**: RuboCop for Ruby style enforcement

## System Dependencies

Before setting up the application, ensure you have:

- **Ruby**: 3.3.9 or higher
- **Rails**: 8.0.4 or higher
- **Database**: PostgreSQL (recommended) or SQLite3
- **Node.js**: For asset compilation
- **Yarn**: For JavaScript package management
- **Image Processing Tools**: ImageMagick or libvips for image manipulation
- **PDF Generation**: Wicked PDF with wkhtmltopdf for PDF generation

## Installation

### 1. Clone the Repository
```bash
git clone <repository-url>
cd expe_quotation
```

### 2. Install Dependencies
```bash
# Install Ruby gems
bundle install

# Install JavaScript packages
yarn install
```

### 3. Database Setup
```bash
# Create databases
rails db:create

# Run migrations
rails db:migrate

# Seed the database with initial data
rails db:seed
```

### 4. Environment Configuration
Copy the example environment file and configure your settings:
```bash
cp .env.example .env
```

Update the environment variables as needed for your setup (database credentials, API keys, etc.).

### 5. Start the Application
```bash
# Start the Rails server
rails server
```

The application will be available at `http://localhost:3000`

## Configuration

### Database Configuration
The application supports multiple databases. Configure in `config/database.yml`:
- PostgreSQL (recommended for production)
- SQLite3 (for development/testing)

### User Roles
The system supports three user roles:
- **Admin**: Full access to all features
- **Salesperson**: Can manage quotations and clients
- **Engineer**: Can work on projects and quotations

### User Status
Users can have different status values:
- **Active**: Can log in and access the system
- **Inactive**: Account is disabled

## Usage

### Getting Started
1. Create an admin user account
2. Add clients to your system
3. Create materials and services catalogs
4. Generate quotations for your projects
5. Track approval workflow
6. Generate PDFs for client delivery

### Key Workflows
- **Quotation Creation**: Create new quotations with multiple items
- **Approval Process**: Send quotations for approval with approval/rejection features
- **PDF Generation**: Export quotations as professional PDF documents
- **File Management**: Attach relevant documents to quotations

## Testing

Run the complete test suite:
```bash
bundle exec rspec
```

Run specific test files:
```bash
# Run model tests
bundle exec rspec spec/models/

# Run controller tests
bundle exec rspec spec/controllers/

# Run request tests
bundle exec rspec spec/requests/
```

## Deployment

### Heroku Deployment
```bash
# Add Heroku Git remote
heroku create your-app-name

# Set buildpacks
heroku buildpacks:set heroku/ruby

# Deploy
git push heroku main

# Run migrations
heroku run rails db:migrate

# Seed data (if needed)
heroku run rails db:seed
```

### Docker Deployment
The application includes a Dockerfile for containerized deployment:
```dockerfile
# Build the image
docker build -t quotation-app .

# Run the container
docker run -p 3000:3000 quotation-app
```

## API Documentation

The application provides a JSON API for most resources. Endpoints include:
- `/api/v1/quotations` - Manage quotations
- `/api/v1/clients` - Manage clients
- `/api/v1/materials` - Access materials catalog
- `/api/v1/services` - Access services catalog

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for your changes
5. Run the test suite (`bundle exec rspec`)
6. Commit your changes (`git commit -am 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Create a new Pull Request

## Security

The application implements several security measures:
- Strong parameters to prevent mass assignment vulnerabilities
- CSRF protection for form submissions
- Authentication and authorization with Devise
- SQL injection protection through ActiveRecord
- XSS protection through automatic HTML escaping

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, please open an issue in the GitHub repository or contact the development team.

## Acknowledgments

- Built with the Ruby on Rails framework
- Uses various open-source gems and libraries
- Inspired by real-world quotation management needs
