**Incident Post-Mortem Report**

**Incident Summary**

**Date of Incident**

12.07.2024

**Impact**

Failure of a critical job post-migration from Postgres 11 Flex to Postgres 14, affecting systems 1, 2, 3, 4, 5, and 6. The job encountered a generic SSL error, causing significant delays in data processing.

**Timeline**

**12.07.2024**

-  Migration from Postgres 11 Flex to Postgres 14 was executed with the assistance of the Production Support and AAF teams. Instances affected: 1, 2, 3, 4, 5, and 6.

**Weekend Post-Migration**

-  Multiple jobs ran successfully. However, one job began to fail.

**Monday, 15.07.2024**

-  **Morning**: Troubleshooting began for the failing job, which presented a generic SSL error. This was particularly puzzling as other scripts and services were successfully connecting to Postgres 14.

-  Initial troubleshooting with Production Support.

-  The issue was escalated to include the US team and the developer.

-  Actions taken:

-  Tested configurations, switching between Postgres 11 and Postgres 14 Flex. Postgres 11 worked; Postgres 14 did not.

-  Manually added Postgres Flex certificates to the trust store of the csurv application (JKS).

**Monday Afternoon**

-  Opened an incident channel for deeper support.

**Tuesday, 16.07.2024**

-  **Morning**: Held a call with all teams to troubleshoot. Took a break to regroup with the AAF team later.

-  In the meantime:

-  Dummy PostgreSQL scripts were created and only worked after pointing to the trust store in an open format (not Java Keystore).

-  Compared UAT and PROD environments:

-  UAT used DigiCert CA signing the certificates.

-  PROD used Microsoft Azure Root CA.

-  Added the CA certificates to Linux default paths (/etc/pki/...) and application default paths (using open certificates).

-  **Afternoon**:

-  Successful connection achieved after running strace for low-level debugging, revealing that the root CA used was from Anaconda, not from the application or the OS.

-  Determined that the Anaconda CA was either inherited/copied from the OS at deployment or statically deployed by the Anaconda package.

-  Resolution was to add the Azure Root CA to the Anaconda root CA.

**Root Cause**

The root cause of the SSL errors was the absence of the Microsoft Azure Root CA in the centrally managed (RHEL) systems' trusted certificate store. This was further compounded by Anaconda's usage of its own certificate bundle, which did not include the necessary CA.

**Resolution**

-  Added Microsoft Azure Root CA to the Anaconda root CA.

**Lessons Learned**

1.  **Certificate Management**:

-  Ensure that all centrally managed systems (RHEL VMs) have an updated and comprehensive set of trusted root certificates, including the Microsoft Azure Root CA.

-  Verify and standardize the certificate trust stores across different environments (PROD, UAT, etc.).

2.  **Tool Dependencies**:

-  Investigate and document dependencies of critical tools like Anaconda, especially regarding security configurations such as SSL certificates.

3.  **Communication and Escalation**:

-  Streamline the communication and escalation process to ensure prompt action by all relevant teams, including the central teams responsible for system-wide configurations.

**Recommendations**

-  **Central Team Assessment**:

-  UBS central team should assess and include the Microsoft Azure Root CA in all systems to prevent similar issues in the future.

-
