# Changelog

## [1.3.3](https://github.com/JacobPEvans/ai-assistant-instructions/compare/v1.3.2...v1.3.3) (2026-03-26)


### Bug Fixes

* clarify dependency versioning policy for trusted vs untrusted actions ([#528](https://github.com/JacobPEvans/ai-assistant-instructions/issues/528)) ([41ed466](https://github.com/JacobPEvans/ai-assistant-instructions/commit/41ed4665d77d92ae9f1fe8db5d9e6c2ce4680148))

## [1.3.2](https://github.com/JacobPEvans/ai-assistant-instructions/compare/v1.3.1...v1.3.2) (2026-03-25)


### Bug Fixes

* add shared nix-tool-policy rule for dev shell repos ([#522](https://github.com/JacobPEvans/ai-assistant-instructions/issues/522)) ([9c4ac5e](https://github.com/JacobPEvans/ai-assistant-instructions/commit/9c4ac5ebef2e37837e612973b3129f0e6b326355))

## [1.3.1](https://github.com/JacobPEvans/ai-assistant-instructions/compare/v1.3.0...v1.3.1) (2026-03-25)


### Bug Fixes

* replace broken MLX routing slots with downloaded models ([#523](https://github.com/JacobPEvans/ai-assistant-instructions/issues/523)) ([bae3b50](https://github.com/JacobPEvans/ai-assistant-instructions/commit/bae3b5059485449cda894584d9ac34f195867aed))

## [1.3.0](https://github.com/JacobPEvans/ai-assistant-instructions/compare/v1.2.1...v1.3.0) (2026-03-21)


### Features

* add pre-integration checklist for new inference backends ([#517](https://github.com/JacobPEvans/ai-assistant-instructions/issues/517)) ([5cc389f](https://github.com/JacobPEvans/ai-assistant-instructions/commit/5cc389f132fa4f1ef4464b419f2ec6f0fa321849))

## [1.2.1](https://github.com/JacobPEvans/ai-assistant-instructions/compare/v1.2.0...v1.2.1) (2026-03-21)


### Bug Fixes

* remove greptile mcp permissions ([#518](https://github.com/JacobPEvans/ai-assistant-instructions/issues/518)) ([608c197](https://github.com/JacobPEvans/ai-assistant-instructions/commit/608c197186096489387913e18e076e5fdf2edfd6))

## [1.2.0](https://github.com/JacobPEvans/ai-assistant-instructions/compare/v1.1.0...v1.2.0) (2026-03-20)


### Features

* add test/lint tool permissions and fix :* format ([#507](https://github.com/JacobPEvans/ai-assistant-instructions/issues/507)) ([85e139c](https://github.com/JacobPEvans/ai-assistant-instructions/commit/85e139cd3671c5de9ed39991bd83507221820558))
* add token economy section to AGENTS.md ([#505](https://github.com/JacobPEvans/ai-assistant-instructions/issues/505)) ([c8fe1ca](https://github.com/JacobPEvans/ai-assistant-instructions/commit/c8fe1caa67b5a632943c5475085e2b139baea7d3))
* auto-approve PAL, HuggingFace, memory, and AWS MCP tools ([#514](https://github.com/JacobPEvans/ai-assistant-instructions/issues/514)) ([3e59464](https://github.com/JacobPEvans/ai-assistant-instructions/commit/3e59464c1bfa738aaf4a0d5cb1a0f990f8a99c56))
* MLX-first model routing — add MLX preferred column, update cloud to 4.6 ([#511](https://github.com/JacobPEvans/ai-assistant-instructions/issues/511)) ([5ee434d](https://github.com/JacobPEvans/ai-assistant-instructions/commit/5ee434de4361c1ec1e21eccaac041864b4b7a9a4))


### Bug Fixes

* add release-please config for manifest mode ([ccdbd2b](https://github.com/JacobPEvans/ai-assistant-instructions/commit/ccdbd2bb39a0e73c90ce0493c78ffc34d369f3df))
* add release-please secrets and sync VERSION ([b327262](https://github.com/JacobPEvans/ai-assistant-instructions/commit/b3272624c1f9688e961267fc8cd4f3fd1df67a74))
* audit tool permissions, agent restrictions, and Bash format migration ([#504](https://github.com/JacobPEvans/ai-assistant-instructions/issues/504)) ([a68d8b5](https://github.com/JacobPEvans/ai-assistant-instructions/commit/a68d8b56352825aaa1fd917db422295f178da234))
* **ci:** use !cancelled() instead of always() in Merge Gate condition ([#501](https://github.com/JacobPEvans/ai-assistant-instructions/issues/501)) ([e6e9f3a](https://github.com/JacobPEvans/ai-assistant-instructions/commit/e6e9f3a6969004db648fb7d06a0b5f3c36a87217))
* remove stale :* format from validate-permissions comment ([#509](https://github.com/JacobPEvans/ai-assistant-instructions/issues/509)) ([a90ba52](https://github.com/JacobPEvans/ai-assistant-instructions/commit/a90ba523515e682506d0fd2066c4cdb288b01c44))
* update MLX port from 11435 to 11436 (screenpipe conflict) ([#513](https://github.com/JacobPEvans/ai-assistant-instructions/issues/513)) ([aa15e32](https://github.com/JacobPEvans/ai-assistant-instructions/commit/aa15e32e8bbe2868c44379f3cf81c47533fc80aa))
* update model routing table and add local model naming guidance ([#506](https://github.com/JacobPEvans/ai-assistant-instructions/issues/506)) ([f47ba79](https://github.com/JacobPEvans/ai-assistant-instructions/commit/f47ba79e45c40a2b116607e2f06669f7f2656987))
* update routing docs for MLX-only, fill TBD entries ([9234191](https://github.com/JacobPEvans/ai-assistant-instructions/commit/923419183fec1813fe439b175fbb39db5d0d4cfc))
* update routing docs for MLX-only, fill TBD entries ([#515](https://github.com/JacobPEvans/ai-assistant-instructions/issues/515)) ([9234191](https://github.com/JacobPEvans/ai-assistant-instructions/commit/923419183fec1813fe439b175fbb39db5d0d4cfc))
* update version bump docs to reflect default semver strategy ([#508](https://github.com/JacobPEvans/ai-assistant-instructions/issues/508)) ([5631835](https://github.com/JacobPEvans/ai-assistant-instructions/commit/563183576662d52526fc84ad47cf3a479a7825a6))

## [1.1.0](https://github.com/JacobPEvans/ai-assistant-instructions/compare/v1.0.1...v1.1.0) (2026-03-11)


### ⚠ BREAKING CHANGES

* **ci:** footers only bump minor (not major) due to versioning: always-bump-minor in the central release-please config. Major bumps require manually editing .release-please-manifest.json.
* Permission format change

### Features

* add 'defaults read' to system command permissions ([#396](https://github.com/JacobPEvans/ai-assistant-instructions/issues/396)) ([13733f3](https://github.com/JacobPEvans/ai-assistant-instructions/commit/13733f3f8a8990135a54ac5300bdf4a3dfdf8ef3))
* add cspell pre-commit hook to prevent spelling errors ([6b7daf4](https://github.com/JacobPEvans/ai-assistant-instructions/commit/6b7daf47b2e5e1696b13fc3b61c2fbacfe1f80a2))
* add direct-execution rule to prevent script generation ([#456](https://github.com/JacobPEvans/ai-assistant-instructions/issues/456)) ([bca3fd3](https://github.com/JacobPEvans/ai-assistant-instructions/commit/bca3fd37e9876c4a9d0a78420257249db5ca0668))
* add four Copilot agentic workflows to gh-aw collection ([#478](https://github.com/JacobPEvans/ai-assistant-instructions/issues/478)) ([007c60f](https://github.com/JacobPEvans/ai-assistant-instructions/commit/007c60f8fc1e930bd0f247d00ef7683f1c7b8fbe))
* add github.github.io to WebFetch allow list ([9421a7f](https://github.com/JacobPEvans/ai-assistant-instructions/commit/9421a7f315d7e1c9fb291d5e2f9bca185c1cf149))
* add issue creation spam prevention system ([a901d23](https://github.com/JacobPEvans/ai-assistant-instructions/commit/a901d2349b1d0f9bbf05120e752bc3d86c00a6b0))
* add MCP greptile permissions ([5f1b8f3](https://github.com/JacobPEvans/ai-assistant-instructions/commit/5f1b8f3ce384facfcf3e3fbb2fd6ea4145ac1565))
* add no-ai-mentions rule for PR comments ([021d8a2](https://github.com/JacobPEvans/ai-assistant-instructions/commit/021d8a26fe9bdeada0e9de02963bdaee73ca12cb))
* add orchestrator role section and simplify subagent patterns ([#421](https://github.com/JacobPEvans/ai-assistant-instructions/issues/421)) ([fb0b68d](https://github.com/JacobPEvans/ai-assistant-instructions/commit/fb0b68d1694175232bbd5180ed35cf7bea71c362))
* add python3 - &lt;&lt; to shell deny rules ([#471](https://github.com/JacobPEvans/ai-assistant-instructions/issues/471)) ([b1822b6](https://github.com/JacobPEvans/ai-assistant-instructions/commit/b1822b6d61670595cd6364742fcf880387630b80))
* add scheduled AI workflow callers ([#489](https://github.com/JacobPEvans/ai-assistant-instructions/issues/489)) ([a1fd9f7](https://github.com/JacobPEvans/ai-assistant-instructions/commit/a1fd9f7d1f7425f32e08b4c99b41a866fb64aae2))
* add testing-philosophy rule for continuous monitoring preference ([#459](https://github.com/JacobPEvans/ai-assistant-instructions/issues/459)) ([7fae45b](https://github.com/JacobPEvans/ai-assistant-instructions/commit/7fae45ba5a49a3813f672a5cccd48ec65b81ccbf))
* adopt conventional branch standard (feature/, bugfix/, chore/) ([#486](https://github.com/JacobPEvans/ai-assistant-instructions/issues/486)) ([25d0494](https://github.com/JacobPEvans/ai-assistant-instructions/commit/25d04946454a3b4d1943f52363aed0d433d50369))
* archive deprecated docs and decommission scripting workflows ([7b4ad6d](https://github.com/JacobPEvans/ai-assistant-instructions/commit/7b4ad6dcb53db8fe06d96901d37bdd46aeafc81c))
* auto-approve git worktree remove --force ([#462](https://github.com/JacobPEvans/ai-assistant-instructions/issues/462)) ([b874d3f](https://github.com/JacobPEvans/ai-assistant-instructions/commit/b874d3f7f60011a04467bac6ec78c13a8c7290f0))
* consolidate python deny rules and block cat &gt; /tmp/ shell bypass ([#464](https://github.com/JacobPEvans/ai-assistant-instructions/issues/464)) ([992402a](https://github.com/JacobPEvans/ai-assistant-instructions/commit/992402a9492923cefdb47a714c545a57bbdf6d74))
* deny Python execution from /dev/ and /tmp/ directories ([#460](https://github.com/JacobPEvans/ai-assistant-instructions/issues/460)) ([6c44f15](https://github.com/JacobPEvans/ai-assistant-instructions/commit/6c44f15e93f255ad18278187c707e8479d182635))
* disable automatic triggers on Claude-executing workflows ([c8a8cbe](https://github.com/JacobPEvans/ai-assistant-instructions/commit/c8a8cbe63e0f7e5f943f3b3492536ecf3c82756c))
* expand shell deny rules + add ecosystem-first guidance ([88a838c](https://github.com/JacobPEvans/ai-assistant-instructions/commit/88a838c2c3f666ea48ef7a8828f6c3ceba0c8524))
* implement dynamic Merge Gate for conditional CI checks ([03e68fe](https://github.com/JacobPEvans/ai-assistant-instructions/commit/03e68fe25be51a335c9f9cdbb41f880ba26e8fce))
* improve agent frontmatter with model selection and trigger terms ([f6f5480](https://github.com/JacobPEvans/ai-assistant-instructions/commit/f6f54805b9853dd4094639811ffd2608cd178343))
* **init-worktree:** symlink .docs/ from repo root into worktrees ([#429](https://github.com/JacobPEvans/ai-assistant-instructions/issues/429)) ([8a2e64d](https://github.com/JacobPEvans/ai-assistant-instructions/commit/8a2e64df5d777d8313f7050039da669412818767))
* migrate 27 auto-loaded rules to on-demand plugin skills ([#496](https://github.com/JacobPEvans/ai-assistant-instructions/issues/496)) ([b90f445](https://github.com/JacobPEvans/ai-assistant-instructions/commit/b90f445f0c2a17c65093cffd95cef1dadb6f24e2))
* optimize command token usage with DRY principles ([#390](https://github.com/JacobPEvans/ai-assistant-instructions/issues/390)) ([c828e91](https://github.com/JacobPEvans/ai-assistant-instructions/commit/c828e915af9628f8767d5f0443f060f9fc807bd4))
* optimize command token usage with DRY principles ([#390](https://github.com/JacobPEvans/ai-assistant-instructions/issues/390)) ([a7186d3](https://github.com/JacobPEvans/ai-assistant-instructions/commit/a7186d39da40fe3c69c217fcdda8e0812a638808))
* phase 4 token optimization - consolidate skills and add conservation guidelines ([4d9fccf](https://github.com/JacobPEvans/ai-assistant-instructions/commit/4d9fccf9822ef93bb70456d5e58b5abe0a7b6b4b))
* **renovate:** extend shared preset for org-wide auto-merge rules ([65a8117](https://github.com/JacobPEvans/ai-assistant-instructions/commit/65a8117f71c1a893e431fdb5edcc3fcbc9f22d7f))
* restore default tools to allowed-tools declarations ([6cdfd55](https://github.com/JacobPEvans/ai-assistant-instructions/commit/6cdfd55c98e3bc4e5144526da29901f037a94d96))
* rewrite direct-execution rule with workflow-first approach ([#467](https://github.com/JacobPEvans/ai-assistant-instructions/issues/467)) ([a9ec9c1](https://github.com/JacobPEvans/ai-assistant-instructions/commit/a9ec9c18080de07b3cfd2bd56cc5e3ce0a686ff3))
* **rules:** add agent-dispatching rule for file tool constraints ([#483](https://github.com/JacobPEvans/ai-assistant-instructions/issues/483)) ([28f9b71](https://github.com/JacobPEvans/ai-assistant-instructions/commit/28f9b71a0920ec1f6b7a5bdf87c1a3ee27827fc1))


### Bug Fixes

* add 'pushable' to cspell dictionary ([58f82ed](https://github.com/JacobPEvans/ai-assistant-instructions/commit/58f82ed9ba821341d94fc46729475e1ea017ae75))
* add 'pushable' to cspell dictionary ([70474ec](https://github.com/JacobPEvans/ai-assistant-instructions/commit/70474ec723d0af17d115d5cf6a633ba17c574f36))
* add minimal allowed-tools to deprecated init-change command ([9d07bdc](https://github.com/JacobPEvans/ai-assistant-instructions/commit/9d07bdc05303726aebbc8ffa5321cee857165dbb))
* add missing technical terms to spell check dictionary ([6f7c524](https://github.com/JacobPEvans/ai-assistant-instructions/commit/6f7c5243b0d0b9986e31ba66b5019c367f8a377d))
* add pip install variants to allow list ([d6974a1](https://github.com/JacobPEvans/ai-assistant-instructions/commit/d6974a122539844acd0c5d03ad0e2822fdf100e1)), closes [#339](https://github.com/JacobPEvans/ai-assistant-instructions/issues/339)
* add shell tools to system allow list ([#402](https://github.com/JacobPEvans/ai-assistant-instructions/issues/402)) ([7c0a5ad](https://github.com/JacobPEvans/ai-assistant-instructions/commit/7c0a5ad2bdb8b358f0f02718c75a3925fe33e8d5))
* add shell tools to system allow list ([#402](https://github.com/JacobPEvans/ai-assistant-instructions/issues/402)) ([453ffda](https://github.com/JacobPEvans/ai-assistant-instructions/commit/453ffdafede14bf3e2976bdf74b9de423d144d46))
* address 14 review feedback items on issue spam prevention system ([41be291](https://github.com/JacobPEvans/ai-assistant-instructions/commit/41be291880d4def66af339cb16da6dd3402b54e2))
* address PR review feedback - fix PR_NUMBER variable reference ([e82ab48](https://github.com/JacobPEvans/ai-assistant-instructions/commit/e82ab48ccc5fec7affdf7ab63a7d0039f7339378))
* address PR review feedback on token optimization ([0c27988](https://github.com/JacobPEvans/ai-assistant-instructions/commit/0c279880cdcdd31b33778358ebee2eba5476d75a))
* address review feedback on validation script and workflow ([31fd791](https://github.com/JacobPEvans/ai-assistant-instructions/commit/31fd7912a20541e136fb4de1ec905bc0ce736c4d))
* align variable naming in resolve-pr-thread-graphql agent ([7059ef0](https://github.com/JacobPEvans/ai-assistant-instructions/commit/7059ef079f925c827990e5e2128dba04d251149f))
* auto-deny pip install and non-Nix package installs ([7c7f1ac](https://github.com/JacobPEvans/ai-assistant-instructions/commit/7c7f1ac90bb4a8b1e1e5e5e49ea1c379af5b1c3a))
* batch resolve multiple issues and remove obsolete 50-comment limit ([#423](https://github.com/JacobPEvans/ai-assistant-instructions/issues/423)) ([de5f47b](https://github.com/JacobPEvans/ai-assistant-instructions/commit/de5f47bb33a5685780d6134afe0824ecda369bdb))
* clarify branch protection is not a blocker for PR-reviewed commits ([1f49b4e](https://github.com/JacobPEvans/ai-assistant-instructions/commit/1f49b4e7ee3161c77638c1d9543a8ad22d018665))
* correct markdown table formatting in phase-4-results.md ([4b402a4](https://github.com/JacobPEvans/ai-assistant-instructions/commit/4b402a49f5e0a0fc836ec36de619e425046451ee))
* correct markdown table formatting in workflows README ([93692db](https://github.com/JacobPEvans/ai-assistant-instructions/commit/93692db1aeb7e5d47cde55a2e94bf52f1657ca72))
* correct off-by-one error in Read tool offset calculation ([f7f1307](https://github.com/JacobPEvans/ai-assistant-instructions/commit/f7f130748ebecfe4c4ba24750a16aea536bcef17))
* correct table formatting in auto-claude.md ([4d0f6b4](https://github.com/JacobPEvans/ai-assistant-instructions/commit/4d0f6b44247b0290d9f1fb75d36550d421f444c4))
* correct token conservation and git workflow documentation in CLAUDE.md ([0828bf4](https://github.com/JacobPEvans/ai-assistant-instructions/commit/0828bf495edf6a0a8780d2e3dc6991c5491fade4))
* correct trigger workflow to target JacobPEvans/nix repository ([#447](https://github.com/JacobPEvans/ai-assistant-instructions/issues/447)) ([6145354](https://github.com/JacobPEvans/ai-assistant-instructions/commit/61453546bbe2e6ee3be238f28ff6dcce662879be))
* correct WebFetch domain matching docs - exact host, not subdomain ([cbf6561](https://github.com/JacobPEvans/ai-assistant-instructions/commit/cbf656114cff309342ae53b91a8c3c7d34852393))
* enforce Read tool usage in pr-thread-resolver agent ([6fc580e](https://github.com/JacobPEvans/ai-assistant-instructions/commit/6fc580e4a4b1c2e31a211860185bbd94525e24cb))
* harden git-rebase skill with explicit error handling ([00a8be4](https://github.com/JacobPEvans/ai-assistant-instructions/commit/00a8be42c839b594af93ad141e5d0e4ef1383f3f))
* improve YAML formatting with folded block scalars for allowed-tools ([6ad350f](https://github.com/JacobPEvans/ai-assistant-instructions/commit/6ad350f43c8d8c3ff9a2eff0ad3a8a879511c93f))
* install jsonc-parser dependency in cclint validation workflow ([bbb37de](https://github.com/JacobPEvans/ai-assistant-instructions/commit/bbb37de6331bef1c504afd8b146d760177992d4c))
* **lint:** wrap long line in workspace-management.md ([36e35af](https://github.com/JacobPEvans/ai-assistant-instructions/commit/36e35af77d9125f8ea157b0c44ecd264f1903f39))
* make diverged branches fix self-contained ([04f7f66](https://github.com/JacobPEvans/ai-assistant-instructions/commit/04f7f661901c854ce34ad3c8fcc0e2ab0816e06f))
* **permissions:** allow grep and echo commands ([#419](https://github.com/JacobPEvans/ai-assistant-instructions/issues/419)) ([9714c47](https://github.com/JacobPEvans/ai-assistant-instructions/commit/9714c47c1f0e7d0d9f0c397793f0e644dd6f9c25))
* prevent zombie PRs and anchor issue/PR linking as auto-loading rules ([96bf8d2](https://github.com/JacobPEvans/ai-assistant-instructions/commit/96bf8d2cc8d69600180c774ba33a81a202cffa5c))
* remove :* suffix from all permission files ([#415](https://github.com/JacobPEvans/ai-assistant-instructions/issues/415)) ([e593bdb](https://github.com/JacobPEvans/ai-assistant-instructions/commit/e593bdbd04194ad02ea24d37fed91840711e3cfe))
* remove duplicate permissions (basename, tr) ([#417](https://github.com/JacobPEvans/ai-assistant-instructions/issues/417)) ([d79fdc6](https://github.com/JacobPEvans/ai-assistant-instructions/commit/d79fdc6538d3ab43572d3e7b0f35c99c27f866cd))
* remove gh pr merge - it bypasses commit signing ([e50c8ba](https://github.com/JacobPEvans/ai-assistant-instructions/commit/e50c8ba8aeaa3f6f9ee51e9c5f1437b6bde4e55b))
* remove redundant allow files covered by core.json wildcards ([601fcad](https://github.com/JacobPEvans/ai-assistant-instructions/commit/601fcad86a6270b702858ebba1f85befbb4a327c))
* remove redundant default permissions from allowed-tools ([c316013](https://github.com/JacobPEvans/ai-assistant-instructions/commit/c31601320b2edb1817d44d0a6548a79f163715de))
* replace bash for loops with parallel tool calls in skills ([2941636](https://github.com/JacobPEvans/ai-assistant-instructions/commit/29416363183dbcb9c18dcd153f7d36d008c1a722))
* replace for loop with find + while read in validate-commands.sh ([#407](https://github.com/JacobPEvans/ai-assistant-instructions/issues/407)) ([43c53d8](https://github.com/JacobPEvans/ai-assistant-instructions/commit/43c53d8ebb4bd5f4de29a64be916a83b385c1f81))
* replace prose bullet list with @ cross-reference in github-issue-standards ([#480](https://github.com/JacobPEvans/ai-assistant-instructions/issues/480)) ([d27d335](https://github.com/JacobPEvans/ai-assistant-instructions/commit/d27d33507754a5242d96ded5400a702324b2db51))
* resolve cclint error and add pre-push validation hook ([7748eac](https://github.com/JacobPEvans/ai-assistant-instructions/commit/7748eac867e406188f723c74bc1c2dd082f51983))
* resolve CI link failures and add lychee pre-commit hook ([#381](https://github.com/JacobPEvans/ai-assistant-instructions/issues/381)) ([ee734f0](https://github.com/JacobPEvans/ai-assistant-instructions/commit/ee734f06c1d4a09c3fbb829f07202e3ae1e618ce))
* resolve CI lint failures ([2a699c5](https://github.com/JacobPEvans/ai-assistant-instructions/commit/2a699c517efee9fd3073ef7a139f6a938a0ee4a2))
* resolve CodeQL alerts and review feedback ([f702967](https://github.com/JacobPEvans/ai-assistant-instructions/commit/f702967b2ccd784d5c16973738c33567d39aeb0c))
* resolve multiple issues from comprehensive triage ([#427](https://github.com/JacobPEvans/ai-assistant-instructions/issues/427)) ([7f1bb19](https://github.com/JacobPEvans/ai-assistant-instructions/commit/7f1bb19bda47211388e58303f29b061d1ba79625))
* resolve PR review feedback - command documentation improvements ([95b93bf](https://github.com/JacobPEvans/ai-assistant-instructions/commit/95b93bfeaf061db6ab41136b64608a2ba32d3797))
* resolve PR review feedback - paths, script cleanup, documentation ([ab44493](https://github.com/JacobPEvans/ai-assistant-instructions/commit/ab4449366033e8ea04eed0b7ea50c40ccdb72b9d))
* resolve pre-commit hook errors ([a953bca](https://github.com/JacobPEvans/ai-assistant-instructions/commit/a953bca40924359e1f3674fcf3d589d577c60bff))
* restore default tools in agent allowed-tools lists ([bb33dac](https://github.com/JacobPEvans/ai-assistant-instructions/commit/bb33dacb64185af163cd912f94256030715c7809))
* revert YAML folded block scalars to single-line format ([8ce5cde](https://github.com/JacobPEvans/ai-assistant-instructions/commit/8ce5cdeff9a37c79111614822470d22af7bb0d9e))
* **rules:** strengthen orphan mandate and add bot PR exemption ([#484](https://github.com/JacobPEvans/ai-assistant-instructions/issues/484)) ([3c7c393](https://github.com/JacobPEvans/ai-assistant-instructions/commit/3c7c3937b32846892f115a886b1eb8b2d74ded79))
* simplify MCP greptile permissions using wildcard only ([35c150a](https://github.com/JacobPEvans/ai-assistant-instructions/commit/35c150ada4daa59176c0b99a1be611d1c8020181))
* use matchPackagePrefixes for safer pattern matching ([f8c9f3d](https://github.com/JacobPEvans/ai-assistant-instructions/commit/f8c9f3d180beef08554dfc89db646b0454881250))
* wrap long line in resolve-pr-thread-graphql agent Role section ([47fc269](https://github.com/JacobPEvans/ai-assistant-instructions/commit/47fc269723bf573c0f3d9c1b972ad7ea900d3ea1))


### Miscellaneous Chores

* **ci:** remove redundant local release-please config ([#498](https://github.com/JacobPEvans/ai-assistant-instructions/issues/498)) ([f5e4675](https://github.com/JacobPEvans/ai-assistant-instructions/commit/f5e467557a7b83d1a6d8d0f1069ae4a7ca84c52c))
