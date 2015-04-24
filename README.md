omni-front
==========

Landing page and small site based on html5 template 'Helios' (CC-BY from html5up)

## Developing for the Omni Commons Website

The best way to add changes to the website is to fork the main repository ([github.com/omnicommons/omnicommons.org](https://github.com/omnicommons/omnicommons.org)) then clone your fork to your local machine and test your changes locally before committing a pull request.

The following text will go over how to get the code on to your local machine and how to configure the machine to display the website, read on!

### Fork, Clone, and Configure the Upstream

We assume you already know how to fork a github.com repository, if not please check out [github's article on repo forking](https://help.github.com/articles/fork-a-repo/)

#### Clone the Repo

Once you have the repository forked you'll want to clone it to your development machine using the clone command.

Here's the command that github user dhornbein used:

`git clone git@github.com:dhornbein/omnicommons.org.git`

**Note:** This command will be different for you as `dhornbein` will be replaced by your github.com user name (or where ever you forked the repo)

#### Configure Remote Upstream

The "remote upstream" is a git remote repo that you pull from for the latest versions of the code. You will add the Omni Common's omnicommons.org repository as the upstream remote location so you can perform `git pull upstream` to pull down any changes to the site since you forked it.

First we'll add the upstream remote, you can copy and paste the line below:

`git remote add upstream git@github.com:omnicommons/omnicommons.org.git`

Now check that it worked by typing `git remote -v` to see all remote repos, it should look like this:

```
origin  git@github.com:dhornbein/omnicommons.org.git (fetch)
origin  git@github.com:dhornbein/omnicommons.org.git (push)
upstream  git@github.com:omnicommons/omnicommons.org.git (fetch)
upstream  git@github.com:omnicommons/omnicommons.org.git (push)
```

Basically this is saying that the **origin** of the files is at your (show as dhornbein's) forked repo and the **upstream** destination is the Omni Common's repo.

### Setting up Server Side Includes on Localhost

The Omni Commons website uses Server Side Includes (SSI) to pull in head, nav, and footer html from the `/includes` folder. So we need to set up your local environment to handle this. Much of the following information is taken from [linuxtopia.org's how to guide on apache ssi](http://www.linuxtopia.org/HowToGuides/apache_ssi.html).

The SSI strings look like this:

`<!--#include virtual="/includes/nav.html" -->`

Once SSI is enabled this line will be replaced by the content of `/includes/nav.html`. This allows us to edit the nav *once* and have those changes appear on all pages with the above snippet.

#### Enable mod_include

The first thing to do is ensure that your server has the mod_include module installed and enabled.

The following instructions were tested on an Mac OS X (10.9) machine but should work on any Linux machine as well. 

First we will examine the Apache Config file `httpd.conf` typically located at:

`/etc/apache2/httpd.conf`

Make sure that the includes modual is present and active by searching for `mod_include` within the `httpd.conf` file, look for this line:

`LoadModule include_module libexec/apache2/mod_include.so`

Check that there isn't a hash (#) in front of the above text (you're text might differ slightly).

##### Turn on Includes

You'll want to turn on the include option through your virtual host by adding:

`Options +Includes`

Here's Drew's vhost as an example:

```
<Virtualhost *:80>
    VirtualDocumentRoot "/Users/drew/www/%-2/"
    ServerName vhosts.localhost
    ServerAlias *.localhost
    ErrorLog "/var/log/apache2/vhosts.localhost-error_log"
    <Directory "/Users/drew/www/*">
        Options Indexes FollowSymLinks +Includes
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
</Virtualhost>
```

*Side Note: Drew is using a nifty trick to automagically add folders in `/Users/drew/www/` to their virtual host, you can read more about that on [Glen Scott's blog post Simple Development Hosts on Mac](http://www.glenscott.co.uk/blog/simple-development-hosts-on-mac/)*

Pay attention to the line where `+Includes` has been added:

`Options Indexes FollowSymLinks +Includes`

##### Configure Apache to Handle Includes

Now we need to tell Apache to scan the proper files for includes. Typically, due to the extra server overhead, this is done only to files that are specified as having includes by using a special extension `.shtml` to indicate to the system that they should be scanned.

The OmniCommons website uses `.html` throughout, so we simply need to tell our local apache server to scan all `.html` files for includes.

Go back to your `httpd.conf` and find the line with `#AddOutputFilter INCLUDES .shtml` now add under that line:

`AddOutputFilter INCLUDES .html`

The hash (#) indicates that a line is commented out, because we want the config file to read our command we omit that hash. So this command is adding an output filter (`AddOutputFilter`) that applies Includes (`INCLUDES`) to all html files (`.html`).

You should now be able to visit your virtual host, in Drew's case it is `omnicommons.localhost`.

**Remember:** The apache include will *not* run if you open the .html file directly in your browser, it must be served from the virtual host.

