#!/usr/bin/env bats

DOCKER_COMPOSE_FILE="${BATS_TEST_DIRNAME}/php-5.3_fpm_pm_max_spare_servers.yml"

container() {
  echo "$(docker-compose -f ${DOCKER_COMPOSE_FILE} ps php | grep php | awk '{ print $1 }')"
}

setup() {
  docker-compose -f "${DOCKER_COMPOSE_FILE}" up -d

  sleep 20
}

teardown() {
  docker-compose -f "${DOCKER_COMPOSE_FILE}" kill
  docker-compose -f "${DOCKER_COMPOSE_FILE}" rm --force
}

@test "php-5.3: fpm: pm.max_spare_servers" {
  run docker exec "$(container)" /bin/su - root -mc "cat /usr/local/src/phpfarm/inst/current/etc/pool.d/www.conf | grep 'pm.max_spare_servers'"

  [ "${status}" -eq 0 ]
  [[ "${output}" == *"6"* ]]
}
