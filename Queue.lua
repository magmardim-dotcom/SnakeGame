local Queue = {}
Queue.__index = Queue

-- Конструктор
function Queue.new()
    return setmetatable({
        data = {},   -- таблица, где хранятся элементы
        head = 1,    -- индекс первого элемента (который будет вытащен)
        tail = 0,    -- индекс последнего элемента (последний добавленный)
    }, Queue)
end

-- Добавить элемент в конец очереди
function Queue:enqueue(item)
    self.tail = self.tail + 1
    self.data[self.tail] = item
end

-- Удалить и вернуть первый элемент; nil если очередь пуста
function Queue:dequeue()
    if self:isEmpty() then
        return nil
    end
    local item = self.data[self.head]
    self.data[self.head] = nil          -- освобождаем память
    self.head = self.head + 1
    -- Сбрасываем индексы, чтобы они не росли бесконечно
    if self.head > self.tail then
        self.head, self.tail = 1, 0
    end
    return item
end

-- Вернуть первый элемент без удаления
function Queue:peek()
    if self:isEmpty() then
        return nil
    end
    return self.data[self.head]
end

-- Проверить, пуста ли очередь
function Queue:isEmpty()
    return self.head > self.tail
end

-- Количество элементов
function Queue:size()
    return self.tail - self.head + 1
end

return Queue
