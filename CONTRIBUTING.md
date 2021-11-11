<!-- omit in toc -->
# Contribution Guide
Welcome to the Open Network Edge Services Software (OpenNESS) project. OpenNESS is an open-source solution that is enriched by people like — you. Your contributions drive the network & enterprise edge computing!

The rest of this document consists of the following sections:

- [Code of Conduct](#code-of-conduct)
- [Maintainers](#maintainers)
- [Technical Steering Committee](#technical-steering-committee)
- [Submitting Changes](#submitting-changes)
- [Contribution Acceptance Flow](#contribution-acceptance-flow)
- [How to report an issue/bug/enhancement](#how-to-report-an-issuebugenhancement)
- [OpenNESS Release Schedule](#openness-release-schedule)
- [Resources](#resources)
- [Style Guide / Coding conventions](#style-guide--coding-conventions)
- [Where can I ask for help?](#where-can-i-ask-for-help)
- [License](#license)

## Code of Conduct
We at the OpenNESS community adhere to [Contributor Covenant](https://www.contributor-covenant.org/) as our Code of Conduct, and we expect project participants to adhere to it. Please read [the full text](CODE_OF_CONDUCT.md) so that you can understand what actions will and will not be tolerated.

Instances of abusive, harassing or otherwise unacceptable behavior should be reported by contacting info@mail.openness.org.

## Maintainers
Maintainers act as the gatekeeper to the code - ensuring that coding standards, quality, and functionality of code are maintained by the contributors. Any additions to the source code must be approved by the appropriate maintainer before they are added. The maintainers' role include:

* Ensuring that any code submitted is of the appropriate quality.
* Ensuring that any code submitted is accompanied with appropriate documentation.
* Ensuring that any code submitted has been reviewed by peers.
* Ensuring that the relevant documentation is kept up to date with the code.
* Ensuring that any identified bugs in the relevant code are captured in the issues backlog.
* Ensuring that the unit, integration, and regression tests are appropriate for the relevant components.
* Ensuring that the contribution does not infringe others' Intellectual Property or the appropriate license and that it is in compliance with [Developer Certificate of Origin](http://developercertificate.org/).
* Answering questions/emails on the relevant areas of the OpenNESS code base.

## Technical Steering Committee
Any contributor can ask for a topic to be added to the Technical Steering Committee agenda by sending an email to developer@mail.openness.org. The committee members will add any topic of interest to the agenda. The minutes of Technical Steering Committee meetings will be published within a reasonable time.

The Technical Steering Committee roles include:

* Voting on all matters requiring a decision from the Technical Steering Committee.
* Resolving any technical disputes. Anybody who disagree with the resolution of a technical issue can request that the Technical Steering Committee review the issue and make a decision on it. All reasonable steps to resolve the dispute via consensus should be taken before escalating to the Technical Steering Committee. If the Technical Steering Committee Chair concludes that this has not happened, they can refer the issue back to the complainant to take further action before escalating it to the Technical Steering Committee. The decision of the Technical Steering Committee on any technical disputes will be final and all project contributors are expected to comply. If a Maintainer or Committer fails to comply with a decision of the Technical Steering Committee, the Technical Steering Committee will may take any necessary steps to enforce its decision, including replacing the Maintainer/Committer.
* Any new project repositories must be approved by the Technical Steering Committee.

## Submitting Changes
Inbound contributions are done through [pull requests](https://github.com/smart-edge-open/edgeapps/pulls) which include code changes, enhancements, bug fixes or new applications/features. If you are getting started, you may refer to Github's [how-to](https://help.github.com/articles/using-pull-requests/). With your contributions, we expect that you:

* certify that you wrote and/or have the right to submit the pull request,
* agree with the [Developer Certificate of Origin](http://developercertificate.org/),
* sign-off your contribution with `Signed-off-by` tag in the commit message(s)
* comply with OpenNESS [licensing](#license),
* pass all Continuous Integration & Continuous Delivery (CI/CD) tools' checks,
* test and verify the proper behaviour of your code, and
* accompany the contribution with good quality documentation.

Signing off the contribution is performed by the command `git commit --signoff` which certifies that you wrote it or otherwise have the right to pass it on as an open-source contribution.

Application contributors have the implicit commitment to continually support their applications in whenever a bug is discovered or a test is broken due to the publication of a new release.

It is always admired when application contributors provide end-to-end acceptance test methods.

Big contributions, ideas or controversial features should be discussed with the developers' community and with the Technical Steering Committee through a Request for Comments (RFC). This is an essential early step to bring everybody to a common level of understanding so that when the final implementation is pushed, there will be common consensus of the acceptability of the contribution and smooth integration of it to the mainline. Requests for Comments should be submitted through a pull request prefixed with `[RFC]` in the title.

## Contribution Acceptance Flow
1. A contributor creates a pull request with their changes.
2. Continuous Integration & Continuous Delivery (CI/CD) tools will be automatically triggered and their results are returned into the pull request.
3. The contributor resolves all findings reported by CI/CD verifications.
4. The contributor invites reviewers to the pull request and addresses their comments/feedback.
5. Every pull request must receive 2 approvals in order to go forward with merging.
6. The maintainer(s) must review and ensure that the change(s) introduced by the pull request meets the acceptance criteria.
6. Merging the pull requests can only be performed by the maintainer(s).

## How to report an issue/bug/enhancement
It is encouraged to use the [GitHub Issues](https://github.com/smart-edge-open/edgeapps/issues) tool to report any bug, issue, enhancement or to seek help.

## Resources
Below are some useful resources for getting started with OpenNESS:
* [OpenNESS release notes](https://github.com/smart-edge-open/specs/blob/master/openness_releasenotes.md)
* [OpenNESS solution index](https://github.com/smart-edge-open/specs/blob/master/README.md)
* [OpenNESS architecture and solution overview](https://github.com/smart-edge-open/specs/blob/master/doc/architecture.md)
* [OpenNESS getting started guide — network edge](https://github.com/smart-edge-open/specs/blob/master/doc/getting-started/network-edge/controller-edge-node-setup.md)
* [OpenNESS getting started guide — on-premises](https://github.com/smart-edge-open/specs/blob/master/doc/getting-started/on-premises/controller-edge-node-setup.md)
* [OpenNESS application onboarding — network edge](https://github.com/smart-edge-open/specs/blob/master/doc/applications-onboard/network-edge-applications-onboarding.md)
* [OpenNESS application onboarding — on-premises](https://github.com/smart-edge-open/specs/blob/master/doc/applications-onboard/on-premises-applications-onboarding.md)
* [OpenNESS application development and porting guide](https://github.com/smart-edge-open/specs/blob/master/doc/applications/openness_appguide.md)

## Style Guide / Coding conventions
All contributions must follow the [Development Guide](DEVELOPING.md).

## Where can I ask for help?
General queries or discussions can be exercised on the OpenNESS developers' mailing list: [developer@mail.openness.org](mailto:developer@mail.openness.org).

## License
OpenNESS is licensed under [Apache License, Version 2.0](LICENSE). By contributing to the project, you agree to the license and copyright terms therein and release your contribution under these terms.
