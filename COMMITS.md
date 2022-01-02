# Git commits messages

---

This project follow Conventional Commits, A specification for adding human and
machine readable meaning to commit messages.

```bash
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

The commit contains the following structural elements, to communicate intent to the consumers of your library:
+ type: the type of commit (feature|bugfix)
  + fix: a commit of the type fix patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
  + feat: a commit of the type feat introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
+ scope: This is optional, but indicate a specific scope;
+ description: show what was done in the commit;
+ body: Full description, if descript not enough;
+ footer: This is optional, but agregate additional information about commit, lake revisor, references, millistone and others.

## Examples
### Commit message with description and breaking change footer
```bash
feat: allow provided config object to extend other configs
BREAKING CHANGE: `extends` key in config file is now used for extending other config files
```

## Commit message with ! to draw attention to breaking change
```shell
feat!: send an email to the customer when a product is shipped
```

## Commit message with scope and ! to draw attention to breaking change
```shell
feat(api)!: send an email to the customer when a product is shipped
```

## Commit message with both ! and BREAKING CHANGE footer
```shell
chore!: drop support for Node 6
```


BREAKING CHANGE: use JavaScript features not available in Node 6.
## Commit message with no body
```shell
docs: correct spelling of CHANGELOG
```

## Commit message with scope
```shell
feat(lang): add polish language
```

## Commit message with multi-paragraph body and multiple footers
```shell
fix: prevent racing of requests

Introduce a request id and a reference to latest request. Dismiss
incoming responses other than from latest request.

Remove timeouts which were used to mitigate the racing issue but are
obsolete now.

Reviewed-by: Z
Refs: #123
```


The full specification maybe access on [english lang](https://www.conventionalcommits.org/en/v1.0.0/#specification) or others languages about [Brazilian Portuguese](https://www.conventionalcommits.org/pt-br/v1.0.0/#specification).
