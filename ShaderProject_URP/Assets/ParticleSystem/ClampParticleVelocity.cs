using UnityEngine;
using UnityEngine.Serialization;

public class ClampParticleVelocity : MonoBehaviour
{
    [SerializeField] float maxMagnitude = 1;
    [FormerlySerializedAs("particleSystem")] [SerializeField] ParticleSystem _particleSystem = null;

    private void Update()
    {
        if(_particleSystem)
        {
            ParticleSystem.Particle[] particles = new ParticleSystem.Particle[_particleSystem.particleCount];
            _particleSystem.GetParticles(particles);

            for(int i = particles.Length - 1; i >= 0; i--)
            {
                particles[i].velocity = particles[i].velocity.magnitude > maxMagnitude ?
                    particles[i].velocity = particles[i].velocity.normalized * maxMagnitude : particles[i].velocity;
            }

            _particleSystem.SetParticles(particles);
        }
    }
}
