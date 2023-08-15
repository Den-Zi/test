<?php
declare(strict_types=1);

namespace SlaveMarket\Lease;

use SlaveMarket\Master\MastersRepository;
use SlaveMarket\Slave\SlavesRepository;

/**
 * Операция "Арендовать раба"
 */
class LeaseOperation
{
    public function __construct(
        private LeaseContractRepository $contractsRepo,
        private MastersRepository $mastersRepo,
        private SlavesRepository $slavesRepo,
    ) {
    }

    /**
     * Выполнить операцию
     *
     * @param LeaseRequest $request
     * @return LeaseResponse
     */
    public function run(LeaseRequest $request): LeaseResponse
    {
        $requestedHours = (new LeaseHourRange($request->timeFrom, $request->timeTill))
            ->getLeaseHours();
        $master = $this->mastersRepo->getById($request->masterId);
        $slave = $this->slavesRepo->getById($request->slaveId);
        $response = new LeaseResponse();

        $existedContracts = $this->contractsRepo->getForSlave(
            $request->slaveId,
            $request->timeFrom,
            $request->timeTill
        );
        if ($existedContracts) {
            $busyHours = $this->getIntersectedBusyHours(
                array_map(
                    fn($requestedHour) => $requestedHour->getDateString(),
                    $requestedHours
                ),
                $existedContracts
            );
            $response->addError(
                'Ошибка. Раб #' . $slave->getId() . '"' . $slave->getName() .'"' .
                ' занят. Занятые часы: ' . join(', ', $busyHours)
            );
            return $response;
        }

        $totalPrice = count($requestedHours) * $slave->getPricePerHour();
        $contract = new LeaseContract(
            $master,
            $slave,
            $totalPrice,
            $requestedHours
        );
        $response->setLeaseContract($contract);
        return $response;
    }

    /**
     * Получает часы, которые находятся в пересечении между запрашиваемыми
     * для аренды часами и уже занятыми в существующих контрактах
     */
    private function getIntersectedBusyHours(array $requestedHours, array $contracts): array
    {
        $busyHours = [];
        foreach ($contracts as $contract) {
            $hours = array_map(
                fn($leasedHour) => $leasedHour->getDateString(),
                $contract->leasedHours
            );
            $busyHours = [$busyHours, ...$hours];
        }

        return array_filter($busyHours,
            fn($busyHour) => in_array($busyHour, $requestedHours));
    }
}
