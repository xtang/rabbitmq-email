PROJECT = rabbitmq_email

DEPS = amqp_client gen_smtp
ifeq ($(EICONV),1)
DEPS += eiconv
endif

TEST_DEPS = rabbit

DEP_PLUGINS = rabbit_common/mk/rabbitmq-plugin.mk

NO_AUTOPATCH += gen_smtp eiconv

# use the patched gen_smtp from my fork
dep_gen_smtp = git https://github.com/gotthardp/gen_smtp.git master
dep_eiconv = git https://github.com/zotonic/eiconv.git master

# FIXME: Use erlang.mk patched for RabbitMQ, while waiting for PRs to be
# reviewed and merged.

ERLANG_MK_REPO = https://github.com/rabbitmq/erlang.mk.git
ERLANG_MK_COMMIT = rabbitmq-tmp

current_rmq_ref = stable
include rabbitmq-components.mk
include erlang.mk

# --------------------------------------------------------------------
# Testing.
# --------------------------------------------------------------------

samples: test/data/samples.zip tests

test/data/samples.zip:
	wget http://www.hunnysoft.com/mime/samples/samples.zip -O $@
	unzip $@ -d $(@D)

WITH_BROKER_TEST_COMMANDS := \
        eunit:test(rabbit_email_tests,[verbose,{report,{eunit_surefire,[{dir,\"test\"}]}}])
#WITH_BROKER_TEST_MAKEVARS := \
#        RABBITMQ_CONFIG_FILE=$(CURDIR)/test/rabbit-test

# end of file
