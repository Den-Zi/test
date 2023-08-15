<?php
declare(strict_types=1);

namespace SlaveMarket\Lease;

/**
 * Арендованный диапазон часов
 */
class LeaseHourRange
{
    public function __construct(
        private string $startTime,
        private string $endTime
    ) {
    }

    /**
     * Возвращает часы аренды, которые входят в данный диапазон
     * return LeaseHour[]
     */
    public function getLeaseHours() : array
    {
        $hours = [];
        $startDateTime = \DateTime::createFromFormat('Y-m-d H:i:s', $this->startTime);
        $endDateTime = \DateTime::createFromFormat('Y-m-d H:i:s', $this->endTime);
        $isSameDate = $startDateTime->format('Y-m-d') === $endDateTime->format('Y-m-d');
        if ($isSameDate) {
            $date = $startDateTime->format('Y-m-d');
            $startHour = (int)$startDateTime->format('H');
            $endHour = (int)$endDateTime->format('H');
            for ($hour = $startHour; $hour <= $endHour; $hour++) {
                $hours[] = new LeaseHour($date . ' ' . $hour);
            }
        } else {
            // случай, когда передаётся промежуток в один или несколько дней
        }

        return $hours;
    }
}
