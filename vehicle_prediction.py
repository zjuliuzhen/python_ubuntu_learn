import numpy as np
import matplotlib.pyplot as plt


def vehicle_prediction(state, control, dt, L):
    """
    根据当前状态和控制量，预测下一时刻的状态
    """
    x, y, theta = state
    v, delta = control
    
    # ============================================================
    # TODO: 请参考工单中的公式图片，补全以下三行代码
    # ============================================================
    # 提示：使用 np.cos(), np.sin(), np.tan()
    # 变量说明：
    #   x, y, theta - 当前状态（位置和航向角）
    #   v, delta    - 控制量（速度和前轮转角）
    #   dt          - 时间步长
    #   L           - 车辆轴距
    # ============================================================
    
    x_next = x + v * np.cos(theta) * dt
    y_next = y + v *np.sin(theta) * dt
    theta_next = theta + (v / L) * np.tan(delta) * dt

    return np.array([x_next, y_next, theta_next])


# ============================================================
# 测试代码（请不要修改下面的内容）
# ============================================================

def run_test():
    # 车辆参数
    L = 2.8          # 轴距 (米)
    dt = 0.1         # 时间步长 (秒)
    total_time = 3.0 # 总仿真时间 (秒)
    steps = int(total_time / dt)
    
    # 初始状态
    state = np.array([0.0, 0.0, 0.0])
    trajectory = [state.copy()]
    
    print("=" * 60)
    print("Vehicle Kinematic Model Prediction")
    print("=" * 60)
    print(f"{'Step':<6} {'x (m)':<10} {'y (m)':<10} {'Heading(deg)':<12}")
    print("-" * 60)
    
    for i in range(steps):
        t = i * dt
        if t < 1.0:
            control = [5.0, 0.0]
        else:
            control = [5.0, np.radians(20)]
        
        state = vehicle_prediction(state, control, dt, L)
        trajectory.append(state.copy())
        
        if i % 10 == 0:
            print(f"{i+1:<6} {state[0]:<10.3f} {state[1]:<10.3f} {np.degrees(state[2]):<12.1f}")
    
    # 绘图
    trajectory = np.array(trajectory)
    plt.figure(figsize=(10, 8))
    plt.plot(trajectory[:, 0], trajectory[:, 1], 'b-', linewidth=2, label='Predicted Trajectory')
    plt.plot(trajectory[0, 0], trajectory[0, 1], 'go', markersize=10, label='Start')
    plt.plot(trajectory[-1, 0], trajectory[-1, 1], 'ro', markersize=10, label='End')
    plt.xlabel('x (m)')
    plt.ylabel('y (m)')
    plt.title('Vehicle Kinematic Model - Trajectory Prediction')
    plt.legend()
    plt.grid(True)
    plt.axis('equal')
    plt.savefig('trajectory.png', dpi=150, bbox_inches='tight')
    
    print("\n" + "=" * 60)
    print("Trajectory plot saved as: trajectory.png")
    print("=" * 60)
    print(f"\nSimulation complete!")
    print(f"End position: ({trajectory[-1, 0]:.3f}, {trajectory[-1, 1]:.3f}) m")
    print(f"End heading: {np.degrees(trajectory[-1, 2]):.1f} deg")


if __name__ == "__main__":
    run_test()
