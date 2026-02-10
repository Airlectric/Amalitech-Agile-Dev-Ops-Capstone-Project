# Definition of Done (DoD)

## Code Quality

- [ ] Code compiles/builds without errors
- [ ] Code follows project style guidelines (ESLint passes with no errors)
- [ ] No console.log or debugger statements left in production code
- [ ] Meaningful variable and function names
- [ ] Functions are small and do one thing well (Single Responsibility Principle)

## Testing

- [ ] All acceptance criteria have corresponding test cases
- [ ] Unit tests pass (≥ 80% code coverage for new code)
- [ ] Integration tests pass
- [ ] All tests pass in CI pipeline before merge

## Documentation

- [ ] Code is self-documenting with clear comments where necessary
- [ ] API endpoints are documented (method, path, request/response format)
- [ ] README is updated with setup instructions
- [ ] Environment variables are documented in .env.example

## Version Control

- [ ] Feature branches are used (no direct commits to main/dev)
- [ ] Commit messages are descriptive and follow conventional commit format
- [ ] Pull requests have clear descriptions linking to user stories
- [ ] Pull requests are reviewed before merge
- [ ] No "big-bang" commits - work is broken into logical, incremental commits

## Security

- [ ] No secrets or credentials committed to version control
- [ ] Passwords are hashed (bcrypt) before storage
- [ ] JWT secrets are environment variables, not hardcoded
- [ ] SQL injection is prevented (parameterized queries)
- [ ] Input validation is implemented on all endpoints

## Database

- [ ] Database schema is documented
- [ ] Migrations are used for schema changes
- [ ] Foreign key relationships are enforced
- [ ] User data is isolated (users can only access their own data)

## DevOps

- [ ] Docker image builds successfully
- [ ] CI pipeline runs successfully on all branches
- [ ] Tests run automatically on every pull request
- [ ] Health endpoint is implemented and working
- [ ] Application runs successfully with `docker-compose up`

## Code Review

- [ ] At least one peer review completed
- [ ] All review comments are addressed
- [ ] Code passes automated quality gates (lint, tests)

## Deployment

- [ ] Application deploys successfully to staging environment
- [ ] Deployed application passes smoke tests
- [ ] Health endpoint returns healthy status post-deployment
