<?php
require_once __DIR__ . '/../db.php';

$master_id = $_GET['master_id'] ?? 0;
$error = '';


try {
    $stmt = $pdo->prepare("SELECT * FROM masters WHERE id = ?");
    $stmt->execute([$master_id]);
    $master = $stmt->fetch();

    if (!$master):
        header('Location: index.php');
        exit;
    endif;
} catch (PDOException $e) {
    die('Ошибка при загрузке данных: ' . $e->getMessage());
}


if ($_SERVER['REQUEST_METHOD'] === 'POST'):
    $service_name = trim($_POST['service_name'] ?? '');
    $service_date = $_POST['service_date'] ?? '';
    $price = $_POST['price'] ?? '';
    $client_name = trim($_POST['client_name'] ?? '');

    if (empty($service_name) || empty($service_date) || empty($price)):
        $error = 'Пожалуйста, заполните все обязательные поля.';
    elseif (!is_numeric($price) || $price < 0):
        $error = 'Стоимость должна быть положительным числом.';
    else:
        try {
            $stmt = $pdo->prepare("INSERT INTO completed_services (master_id, client_name, service_name, service_date, price) VALUES (?, ?, ?, ?, ?)");
            $stmt->execute([$master_id, $client_name, $service_name, $service_date, $price]);
            header('Location: works.php?master_id=' . $master_id);
            exit;
        } catch (PDOException $e) {
            $error = 'Ошибка при добавлении записи: ' . $e->getMessage();
        }
    endif;
endif;
?>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Добавить выполненную работу</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <a href="works.php?master_id=<?= $master_id ?>" class="btn btn-back back-link">← Назад к списку работ</a>

        <h1>Добавить выполненную работу</h1>

        <div class="info-box">
            <p><strong>Мастер:</strong> <?= htmlspecialchars($master['surname'] . ' ' . $master['firstname']) ?></p>
        </div>

        <?php if ($error): ?>
            <div class="message message-error"><?= htmlspecialchars($error) ?></div>
        <?php endif; ?>

        <form method="POST">
            <div class="form-group">
                <label for="service_name">Название услуги *</label>
                <input type="text" id="service_name" name="service_name" required value="<?= htmlspecialchars($_POST['service_name'] ?? '') ?>">
            </div>

            <div class="form-group">
                <label for="client_name">Имя клиента</label>
                <input type="text" id="client_name" name="client_name" value="<?= htmlspecialchars($_POST['client_name'] ?? '') ?>">
            </div>

            <div class="form-group">
                <label for="service_date">Дата выполнения *</label>
                <input type="date" id="service_date" name="service_date" required value="<?= htmlspecialchars($_POST['service_date'] ?? '') ?>">
            </div>

            <div class="form-group">
                <label for="price">Стоимость (руб.) *</label>
                <input type="number" id="price" name="price" step="0.01" min="0" required value="<?= htmlspecialchars($_POST['price'] ?? '') ?>">
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-submit">Добавить</button>
                <a href="works.php?master_id=<?= $master_id ?>" class="btn btn-back">Отмена</a>
            </div>
        </form>
    </div>
</body>
</html>
